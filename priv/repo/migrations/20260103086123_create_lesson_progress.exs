defmodule KitabuLms.Repo.Migrations.CreateLessonProgress do
  use Ecto.Migration

  def change do
    create table(:lesson_progress, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:tenant_id, references(:tenants, type: :binary_id, on_delete: :nothing))
      add(:user_id, references(:users, type: :binary_id, on_delete: :delete_all))
      add(:enrollment_id, references(:enrollments, type: :binary_id, on_delete: :delete_all))
      add(:lesson_id, references(:lessons, type: :binary_id, on_delete: :delete_all))
      add(:status, :string, default: "not_started")
      add(:watch_time_seconds, :integer, default: 0)
      add(:video_position_seconds, :integer, default: 0)
      add(:is_completed, :boolean, default: false)
      add(:completed_at, :utc_datetime)
      add(:last_watched_at, :utc_datetime)
      add(:inserted_at, :utc_datetime, null: false, default: fragment("now()"))
      add(:updated_at, :utc_datetime, null: false, default: fragment("now()"))
    end

    create(index(:lesson_progress, [:tenant_id]))
    create(index(:lesson_progress, [:user_id]))
    create(index(:lesson_progress, [:enrollment_id]))
    create(index(:lesson_progress, [:lesson_id]))
    create(unique_index(:lesson_progress, [:enrollment_id, :lesson_id]))
    create(index(:lesson_progress, [:is_completed]))
  end
end
