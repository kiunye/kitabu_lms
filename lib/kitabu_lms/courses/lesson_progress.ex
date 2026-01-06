defmodule KitabuLms.Courses.LessonProgress do
  @moduledoc """
  Schema for tracking lesson progress with multi-tenant support.
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "lesson_progress" do
    field(:status, :string, default: "not_started")
    field(:watch_time_seconds, :integer, default: 0)
    field(:video_position_seconds, :integer, default: 0)
    field(:is_completed, :boolean, default: false)
    field(:completed_at, :utc_datetime)
    field(:last_watched_at, :utc_datetime)

    belongs_to(:tenant, KitabuLms.Tenants.Tenant)
    belongs_to(:user, KitabuLms.Accounts.User)
    belongs_to(:enrollment, KitabuLms.Courses.Enrollment)
    belongs_to(:lesson, KitabuLms.Courses.Lesson)

    timestamps()
  end

  @doc false
  def changeset(lesson_progress, attrs) do
    lesson_progress
    |> cast(attrs, [
      :status,
      :watch_time_seconds,
      :video_position_seconds,
      :is_completed,
      :completed_at,
      :last_watched_at,
      :tenant_id,
      :user_id,
      :enrollment_id,
      :lesson_id
    ])
    |> validate_required([:user_id, :enrollment_id, :lesson_id])
    |> unique_constraint([:enrollment_id, :lesson_id])
    |> set_last_watched_at()
  end

  defp set_last_watched_at(changeset) do
    if get_change(changeset, :last_watched_at) do
      changeset
    else
      put_change(changeset, :last_watched_at, DateTime.utc_now())
    end
  end

  @doc """
  Status values.
  """
  def status_values, do: ["not_started", "in_progress", "completed"]

  @doc """
  In progress status.
  """
  def in_progress_statuses, do: ["in_progress"]

  @doc """
  Completed status.
  """
  def completed_statuses, do: ["completed"]

  @doc """
  By enrollment scope.
  """
  def by_enrollment(query \\ __MODULE__, enrollment_id) do
    from(lp in query, where: lp.enrollment_id == ^enrollment_id)
  end

  @doc """
  By user scope.
  """
  def by_user(query \\ __MODULE__, user_id) do
    from(lp in query, where: lp.user_id == ^user_id)
  end

  @doc """
  Completed scope.
  """
  def completed(query \\ __MODULE__) do
    from(lp in query, where: lp.status == "completed")
  end

  @doc """
  Updates progress for a lesson.
  """
  def update_progress(lesson_progress, watch_time, video_position) do
    status = if video_position > 0, do: "in_progress", else: lesson_progress.status
    is_completed = if video_position > 0, do: true, else: lesson_progress.is_completed

    completed_at =
      if is_completed && !lesson_progress.completed_at,
        do: DateTime.utc_now(),
        else: lesson_progress.completed_at

    change(lesson_progress, %{
      status: status,
      watch_time_seconds: watch_time,
      video_position_seconds: video_position,
      is_completed: is_completed,
      completed_at: completed_at,
      last_watched_at: DateTime.utc_now()
    })
  end

  @doc """
  Marks as completed.
  """
  def complete(lesson_progress) do
    change(lesson_progress, %{
      status: "completed",
      is_completed: true,
      completed_at: DateTime.utc_now()
    })
  end
end
