defmodule KitabuLms.Repo.Migrations.CreateTenants do
  use Ecto.Migration

  def change do
    create table(:tenants, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:name, :string, null: false)
      add(:slug, :string, null: false)
      add(:domain, :string)
      add(:logo_url, :string)
      add(:primary_color, :string, default: "#00af91")
      add(:secondary_color, :string, default: "#ffc300")
      add(:settings, :map, default: %{})
      add(:is_active, :boolean, default: true)
      add(:subscription_tier, :string, default: "free")
      add(:subscription_expires_at, :utc_datetime)
      add(:inserted_at, :utc_datetime, null: false, default: fragment("now()"))
      add(:updated_at, :utc_datetime, null: false, default: fragment("now()"))
    end

    create(unique_index(:tenants, [:slug]))
    create(unique_index(:tenants, [:domain]))
    create(index(:tenants, [:is_active]))
  end
end
