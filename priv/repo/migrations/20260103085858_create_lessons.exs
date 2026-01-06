defmodule KitabuLms.Repo.Migrations.CreateLessons do
  use Ecto.Migration

  def change do
    create table(:lessons, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:tenant_id, references(:tenants, type: :binary_id, on_delete: :nothing))
      add(:module_id, references(:modules, type: :binary_id, on_delete: :delete_all))
      add(:title, :string, null: false)
      add(:slug, :string, null: false)
      add(:description, :string)
      add(:content, :text)
      add(:video_url, :string)
      add(:video_duration_seconds, :integer, default: 0)
      add(:content_type, :string, default: "video")
      add(:position, :integer, default: 0)
      add(:is_published, :boolean, default: false)
      add(:is_free_preview, :boolean, default: false)
      add(:downloadable_resources, :map)
      add(:inserted_at, :utc_datetime, null: false, default: fragment("now()"))
      add(:updated_at, :utc_datetime, null: false, default: fragment("now()"))
    end

    create(index(:lessons, [:tenant_id]))
    create(index(:lessons, [:module_id]))
    create(unique_index(:lessons, [:module_id, :slug]))
    create(index(:lessons, [:is_published]))
    create(index(:lessons, [:is_free_preview]))
  end
end
