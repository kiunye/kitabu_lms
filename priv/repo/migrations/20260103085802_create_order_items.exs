defmodule KitabuLms.Repo.Migrations.CreateOrderItems do
  use Ecto.Migration

  def change do
    create table(:order_items, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:tenant_id, references(:tenants, type: :binary_id, on_delete: :nothing))
      add(:order_id, references(:orders, type: :binary_id, on_delete: :delete_all))
      add(:course_id, references(:courses, type: :binary_id, on_delete: :nothing))
      add(:course_title, :string, null: false)
      add(:course_slug, :string, null: false)
      add(:price_at_purchase, :decimal, precision: 10, scale: 2)
      add(:currency, :string, default: "USD")
      add(:inserted_at, :utc_datetime, null: false, default: fragment("now()"))
      add(:updated_at, :utc_datetime, null: false, default: fragment("now()"))
    end

    create(index(:order_items, [:tenant_id]))
    create(index(:order_items, [:order_id]))
    create(index(:order_items, [:course_id]))
    create(unique_index(:order_items, [:order_id, :course_id]))
  end
end
