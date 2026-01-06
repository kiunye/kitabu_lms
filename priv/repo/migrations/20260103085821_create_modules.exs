defmodule KitabuLms.Repo.Migrations.CreateModules do
  use Ecto.Migration

  def change do
    create table(:modules, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:tenant_id, references(:tenants, type: :binary_id, on_delete: :nothing))
      add(:course_id, references(:courses, type: :binary_id, on_delete: :delete_all))
      add(:title, :string, null: false)
      add(:slug, :string, null: false)
      add(:description, :string)
      add(:position, :integer, default: 0)
      add(:is_published, :boolean, default: false)
      add(:duration_minutes, :integer, default: 0)
      add(:lesson_count, :integer, default: 0)
      add(:inserted_at, :utc_datetime, null: false, default: fragment("now()"))
      add(:updated_at, :utc_datetime, null: false, default: fragment("now()"))
    end

    create(index(:modules, [:tenant_id]))
    create(index(:modules, [:course_id]))
    create(unique_index(:modules, [:course_id, :slug]))
    create(index(:modules, [:is_published]))
  end
end
