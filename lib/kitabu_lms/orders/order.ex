defmodule KitabuLms.Orders.Order do
  @moduledoc """
  Schema for orders with multi-tenant support.
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "orders" do
    field(:order_number, :string)
    field(:subtotal, :decimal)
    field(:tax, :decimal)
    field(:discount, :decimal)
    field(:total, :decimal)
    field(:currency, :string)
    field(:status, :string, default: "pending")
    field(:payment_provider, :string)
    field(:payment_reference, :string)
    field(:paid_at, :utc_datetime)
    field(:metadata, :map)

    belongs_to(:tenant, KitabuLms.Tenants.Tenant)
    belongs_to(:user, KitabuLms.Accounts.User)

    has_many(:order_items, KitabuLms.Orders.OrderItem, on_delete: :delete_all)
    has_many(:payments, KitabuLms.Payments.Payment)
    has_many(:enrollments, KitabuLms.Courses.Enrollment)

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [
      :order_number,
      :subtotal,
      :tax,
      :discount,
      :total,
      :currency,
      :status,
      :payment_provider,
      :payment_reference,
      :paid_at,
      :metadata,
      :tenant_id,
      :user_id
    ])
    |> validate_required([:order_number, :total, :currency, :status])
    |> validate_length(:order_number, min: 8, max: 50)
    |> validate_number(:total, greater_than_or_equal_to: 0)
    |> unique_constraint([:tenant_id, :order_number])
    |> generate_order_number()
  end

  defp generate_order_number(changeset) do
    if get_change(changeset, :order_number) do
      changeset
    else
      order_number =
        "ORD-#{:crypto.hash(:sha256, :erlang.system_time(:millisecond) |> Integer.to_string()) |> Base.encode16() |> String.slice(0, 8) |> String.upcase()}"

      put_change(changeset, :order_number, order_number)
    end
  end

  @doc """
  Calculates the total from order items.
  """
  def calculate_total(%__MODULE__{order_items: items}) when is_list(items) do
    items
    |> Enum.reduce(Decimal.new("0"), fn item, acc ->
      Decimal.add(acc, item.price_at_purchase)
    end)
  end

  def calculate_total(_), do: Decimal.new("0")

  @doc """
  Status values for orders.
  """
  def status_values do
    ["pending", "processing", "completed", "cancelled", "refunded", "failed"]
  end

  @doc """
  Pending status.
  """
  def pending_statuses, do: ["pending", "processing"]

  @doc """
  Completed status.
  """
  def completed_statuses, do: ["completed"]
end
