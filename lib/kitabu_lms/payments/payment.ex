defmodule KitabuLms.Payments.Payment do
  @moduledoc """
  Schema for payments with multi-tenant support.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "payments" do
    field(:provider, :string)
    field(:reference, :string)
    field(:transaction_id, :string)
    field(:amount, :decimal)
    field(:currency, :string)
    field(:status, :string, default: "pending")
    field(:payment_method, :string)
    field(:gateway_response, :map)
    field(:metadata, :map)
    field(:paid_at, :utc_datetime)
    field(:failed_at, :utc_datetime)

    belongs_to(:tenant, KitabuLms.Tenants.Tenant)
    belongs_to(:order, KitabuLms.Orders.Order)
    belongs_to(:user, KitabuLms.Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [
      :provider,
      :reference,
      :transaction_id,
      :amount,
      :currency,
      :status,
      :payment_method,
      :gateway_response,
      :metadata,
      :paid_at,
      :failed_at,
      :tenant_id,
      :order_id,
      :user_id
    ])
    |> validate_required([:provider, :reference, :amount, :currency, :status])
    |> validate_number(:amount, greater_than_or_equal_to: 0)
    |> unique_constraint([:provider, :reference])
  end

  @doc """
  Provider values.
  """
  def provider_values, do: ["paystack", "stripe", "flutterwave"]

  @doc """
  Status values for payments.
  """
  def status_values do
    ["pending", "processing", "success", "failed", "cancelled", "refunded"]
  end

  @doc """
  Success status.
  """
  def success_statuses, do: ["success"]

  @doc """
  Terminal statuses (no further processing needed).
  """
  def terminal_statuses, do: ["success", "failed", "cancelled", "refunded"]
end
