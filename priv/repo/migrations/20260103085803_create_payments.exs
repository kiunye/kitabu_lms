defmodule KitabuLms.Repo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    create table(:payments, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:tenant_id, references(:tenants, type: :binary_id, on_delete: :nothing))
      add(:order_id, references(:orders, type: :binary_id, on_delete: :nothing))
      add(:user_id, references(:users, type: :binary_id, on_delete: :nothing))
      add(:provider, :string, null: false)
      add(:reference, :string, null: false)
      add(:transaction_id, :string)
      add(:amount, :decimal, precision: 10, scale: 2)
      add(:currency, :string, default: "USD")
      add(:status, :string, default: "pending")
      add(:payment_method, :string)
      add(:gateway_response, :map)
      add(:metadata, :map)
      add(:paid_at, :utc_datetime)
      add(:failed_at, :utc_datetime)
      add(:inserted_at, :utc_datetime, null: false, default: fragment("now()"))
      add(:updated_at, :utc_datetime, null: false, default: fragment("now()"))
    end

    create(index(:payments, [:tenant_id]))
    create(index(:payments, [:order_id]))
    create(index(:payments, [:user_id]))
    create(index(:payments, [:provider]))
    create(index(:payments, [:reference]))
    create(index(:payments, [:status]))
    create(unique_index(:payments, [:provider, :reference]))
  end
end
