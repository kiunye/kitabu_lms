defmodule KitabuLms.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:tenant_id, references(:tenants, type: :binary_id, on_delete: :nothing))
      add(:user_id, references(:users, type: :binary_id, on_delete: :nothing))
      add(:order_number, :string, null: false)
      add(:subtotal, :decimal, precision: 10, scale: 2)
      add(:tax, :decimal, precision: 10, scale: 2)
      add(:discount, :decimal, precision: 10, scale: 2)
      add(:total, :decimal, precision: 10, scale: 2)
      add(:currency, :string, default: "USD")
      add(:status, :string, default: "pending")
      add(:payment_provider, :string)
      add(:payment_reference, :string)
      add(:paid_at, :utc_datetime)
      add(:metadata, :map)
      add(:inserted_at, :utc_datetime, null: false, default: fragment("now()"))
      add(:updated_at, :utc_datetime, null: false, default: fragment("now()"))
    end

    create(index(:orders, [:tenant_id]))
    create(index(:orders, [:user_id]))
    create(index(:orders, [:order_number]))
    create(index(:orders, [:status]))
    create(index(:orders, [:payment_provider]))
    create(unique_index(:orders, [:order_number], name: "orders_order_number_unique"))
  end
end
