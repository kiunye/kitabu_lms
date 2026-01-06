defmodule KitabuLms.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:tenant_id, references(:tenants, type: :binary_id, on_delete: :nothing))
      add(:name, :string, null: false)
      add(:slug, :string, null: false)
      add(:description, :string)
      add(:icon, :string)
      add(:color, :string, default: "#00af91")
      add(:parent_id, references(:categories, type: :binary_id, on_delete: :nothing))
      add(:is_active, :boolean, default: true)
      add(:sort_order, :integer, default: 0)
      add(:course_count, :integer, default: 0)
      add(:inserted_at, :utc_datetime, null: false, default: fragment("now()"))
      add(:updated_at, :utc_datetime, null: false, default: fragment("now()"))
    end

    create(index(:categories, [:tenant_id]))
    create(index(:categories, [:parent_id]))
    create(unique_index(:categories, [:tenant_id, :slug]))
    create(index(:categories, [:is_active]))
  end
end
