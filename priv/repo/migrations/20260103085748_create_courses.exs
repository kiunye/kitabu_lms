defmodule KitabuLms.Repo.Migrations.CreateCourses do
  use Ecto.Migration

  def change do
    create table(:courses, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:tenant_id, references(:tenants, type: :binary_id, on_delete: :nothing))
      add(:instructor_id, references(:instructors, type: :binary_id, on_delete: :nothing))
      add(:category_id, references(:categories, type: :binary_id, on_delete: :nothing))
      add(:title, :string, null: false)
      add(:slug, :string, null: false)
      add(:description, :string)
      add(:short_description, :string)
      add(:thumbnail_url, :string)
      add(:preview_video_url, :string)
      add(:level, :string, default: "beginner")
      add(:language, :string, default: "en")
      add(:duration_hours, :integer, default: 0)
      add(:price, :integer, default: 0)
      add(:original_price, :integer)
      add(:currency, :string, default: "USD")
      add(:is_published, :boolean, default: false)
      add(:is_featured, :boolean, default: false)
      add(:is_free, :boolean, default: false)
      add(:enrollment_count, :integer, default: 0)
      add(:rating, :decimal, precision: 3, scale: 2)
      add(:rating_count, :integer, default: 0)
      add(:metadata, :map, default: %{})
      add(:published_at, :utc_datetime)
      add(:inserted_at, :utc_datetime, null: false, default: fragment("now()"))
      add(:updated_at, :utc_datetime, null: false, default: fragment("now()"))
    end

    create(index(:courses, [:tenant_id]))
    create(index(:courses, [:instructor_id]))
    create(index(:courses, [:category_id]))
    create(unique_index(:courses, [:tenant_id, :slug]))
    create(index(:courses, [:is_published]))
    create(index(:courses, [:is_featured]))
    create(index(:courses, [:level]))
  end
end
