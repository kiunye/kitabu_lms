defmodule KitabuLms.Repo.Migrations.CreateEnrollments do
  use Ecto.Migration

  def change do
    create table(:enrollments, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:tenant_id, references(:tenants, type: :binary_id, on_delete: :nothing))
      add(:user_id, references(:users, type: :binary_id, on_delete: :delete_all))
      add(:course_id, references(:courses, type: :binary_id, on_delete: :delete_all))
      add(:order_id, references(:orders, type: :binary_id, on_delete: :nothing))
      add(:status, :string, default: "active")
      add(:progress_percentage, :integer, default: 0)
      add(:completed_lessons_count, :integer, default: 0)
      add(:total_lessons_count, :integer, default: 0)
      add(:enrolled_at, :utc_datetime, default: fragment("now()"))
      add(:completed_at, :utc_datetime)
      add(:last_accessed_at, :utc_datetime)
      add(:certificate_url, :string)
      add(:inserted_at, :utc_datetime, null: false, default: fragment("now()"))
      add(:updated_at, :utc_datetime, null: false, default: fragment("now()"))
    end

    create(index(:enrollments, [:tenant_id]))
    create(index(:enrollments, [:user_id]))
    create(index(:enrollments, [:course_id]))
    create(index(:enrollments, [:order_id]))
    create(unique_index(:enrollments, [:user_id, :course_id]))
    create(index(:enrollments, [:status]))
  end
end
