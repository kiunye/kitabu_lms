defmodule KitabuLms.Courses.Enrollment do
  @moduledoc """
  Schema for course enrollments with multi-tenant support.
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "enrollments" do
    field(:status, :string, default: "active")
    field(:progress_percentage, :integer, default: 0)
    field(:completed_lessons_count, :integer, default: 0)
    field(:total_lessons_count, :integer, default: 0)
    field(:enrolled_at, :utc_datetime)
    field(:completed_at, :utc_datetime)
    field(:last_accessed_at, :utc_datetime)
    field(:certificate_url, :string)

    belongs_to(:tenant, KitabuLms.Tenants.Tenant)
    belongs_to(:user, KitabuLms.Accounts.User)
    belongs_to(:course, KitabuLms.Courses.Course)
    belongs_to(:order, KitabuLms.Orders.Order)

    has_many(:lesson_progress, KitabuLms.Courses.LessonProgress)

    timestamps()
  end

  @doc false
  def changeset(enrollment, attrs) do
    enrollment
    |> cast(attrs, [
      :status,
      :progress_percentage,
      :completed_lessons_count,
      :total_lessons_count,
      :enrolled_at,
      :completed_at,
      :last_accessed_at,
      :certificate_url,
      :tenant_id,
      :user_id,
      :course_id,
      :order_id
    ])
    |> validate_required([:user_id, :course_id])
    |> unique_constraint([:user_id, :course_id])
    |> set_enrolled_at()
  end

  defp set_enrolled_at(changeset) do
    if get_change(changeset, :enrolled_at) do
      changeset
    else
      put_change(changeset, :enrolled_at, DateTime.utc_now())
    end
  end

  @doc """
  Status values.
  """
  def status_values, do: ["active", "completed", "cancelled", "suspended"]

  @doc """
  Active status.
  """
  def active_statuses, do: ["active"]

  @doc """
  Completed status.
  """
  def completed_statuses, do: ["completed"]

  @doc """
  Active scope.
  """
  def active(query \\ __MODULE__) do
    from(e in query, where: e.status == "active")
  end

  @doc """
  Completed scope.
  """
  def completed(query \\ __MODULE__) do
    from(e in query, where: e.status == "completed")
  end

  @doc """
  By user scope.
  """
  def by_user(query \\ __MODULE__, user_id) do
    from(e in query, where: e.user_id == ^user_id)
  end

  @doc """
  By course scope.
  """
  def by_course(query \\ __MODULE__, course_id) do
    from(e in query, where: e.course_id == ^course_id)
  end

  @doc """
  Updates progress.
  """
  def update_progress(enrollment, completed_count, total_count) do
    percentage = if total_count > 0, do: round(completed_count / total_count * 100), else: 0
    completed_at = if percentage >= 100, do: DateTime.utc_now(), else: nil
    status = if percentage >= 100, do: "completed", else: enrollment.status

    change(enrollment, %{
      progress_percentage: percentage,
      completed_lessons_count: completed_count,
      total_lessons_count: total_count,
      completed_at: completed_at,
      status: status,
      last_accessed_at: DateTime.utc_now()
    })
  end

  @doc """
  Marks as completed.
  """
  def complete(enrollment) do
    change(enrollment, %{
      status: "completed",
      completed_at: DateTime.utc_now(),
      progress_percentage: 100
    })
  end
end
