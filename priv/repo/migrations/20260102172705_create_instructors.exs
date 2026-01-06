defmodule KitabuLms.Repo.Migrations.CreateInstructors do
  use Ecto.Migration

  def change do
    create table(:instructors, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:tenant_id, references(:tenants, type: :binary_id, on_delete: :nothing))
      add(:user_id, references(:users, type: :binary_id, on_delete: :nothing))
      add(:slug, :string, null: false)
      add(:title, :string)
      add(:specialization, :string)
      add(:headline, :string)
      add(:bio, :text)
      add(:avatar_url, :string)
      add(:cover_image_url, :string)
      add(:website_url, :string)
      add(:twitter_handle, :string)
      add(:linkedin_url, :string)
      add(:youtube_url, :string)
      add(:years_of_experience, :integer, default: 0)
      add(:total_students, :integer, default: 0)
      add(:total_courses, :integer, default: 0)
      add(:average_rating, :decimal, precision: 3, scale: 2, default: 0.0)
      add(:is_verified, :boolean, default: false)
      add(:is_active, :boolean, default: true)
      add(:metadata, :map, default: %{})
      add(:inserted_at, :utc_datetime, null: false, default: fragment("now()"))
      add(:updated_at, :utc_datetime, null: false, default: fragment("now()"))
    end

    create(index(:instructors, [:tenant_id]))
    create(index(:instructors, [:user_id]))
    create(unique_index(:instructors, [:tenant_id, :slug]))
    create(index(:instructors, [:is_verified]))
    create(index(:instructors, [:is_active]))
  end
end
