defmodule KitabuLms.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:name, :string, null: false)
      add(:slug, :string, null: false)
      add(:description, :text)
      add(:permissions, :map, default: %{})
      add(:is_system, :boolean, default: false)
      add(:inserted_at, :utc_datetime, null: false, default: fragment("now()"))
      add(:updated_at, :utc_datetime, null: false, default: fragment("now()"))
    end

    create(unique_index(:roles, [:slug]))
    create(index(:roles, [:is_system]))
  end
end
