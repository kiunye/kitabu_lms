defmodule KitabuLms.Orders.OrderItem do
  @moduledoc """
  Schema for order items linking orders to courses.
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "order_items" do
    field(:course_title, :string)
    field(:course_slug, :string)
    field(:price_at_purchase, :decimal)
    field(:currency, :string)

    belongs_to(:tenant, KitabuLms.Tenants.Tenant)
    belongs_to(:order, KitabuLms.Orders.Order)
    belongs_to(:course, KitabuLms.Courses.Course)

    timestamps()
  end

  @doc false
  def changeset(order_item, attrs) do
    order_item
    |> cast(attrs, [
      :course_title,
      :course_slug,
      :price_at_purchase,
      :currency,
      :tenant_id,
      :order_id,
      :course_id
    ])
    |> validate_required([:course_title, :course_slug, :price_at_purchase, :currency])
    |> validate_number(:price_at_purchase, greater_than_or_equal_to: 0)
    |> unique_constraint([:order_id, :course_id])
  end
end
