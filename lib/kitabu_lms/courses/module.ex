defmodule KitabuLms.Courses.Module do
  @moduledoc """
  Schema for course modules with multi-tenant support.
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "modules" do
    field(:title, :string)
    field(:slug, :string)
    field(:description, :string)
    field(:position, :integer, default: 0)
    field(:is_published, :boolean, default: false)
    field(:duration_minutes, :integer, default: 0)
    field(:lesson_count, :integer, default: 0)

    belongs_to(:tenant, KitabuLms.Tenants.Tenant)
    belongs_to(:course, KitabuLms.Courses.Course)

    has_many(:lessons, KitabuLms.Courses.Lesson, on_delete: :delete_all)

    timestamps()
  end

  @doc false
  def changeset(module, attrs) do
    module
    |> cast(attrs, [
      :title,
      :slug,
      :description,
      :position,
      :is_published,
      :duration_minutes,
      :lesson_count,
      :tenant_id,
      :course_id
    ])
    |> validate_required([:title, :slug])
    |> validate_length(:title, min: 2, max: 200)
    |> validate_length(:slug, min: 2, max: 250)
    |> unique_constraint([:course_id, :slug])
    |> generate_slug()
  end

  defp generate_slug(changeset) do
    title = get_change(changeset, :title)

    if title do
      slug =
        title
        |> String.downcase()
        |> String.replace(~r/[^a-z0-9\s-]/, "")
        |> String.replace(~r/\s+/, "-")
        |> String.trim("-")

      put_change(changeset, :slug, slug)
    else
      changeset
    end
  end

  @doc """
  Published scope.
  """
  def published(query \\ __MODULE__) do
    from(m in query, where: m.is_published == true)
  end

  @doc """
  By course scope.
  """
  def by_course(query \\ __MODULE__, course_id) do
    from(m in query, where: m.course_id == ^course_id)
  end

  @doc """
  Ordered by position.
  """
  def ordered(query \\ __MODULE__) do
    from(m in query, order_by: [asc: m.position])
  end
end
