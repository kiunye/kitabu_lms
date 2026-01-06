defmodule KitabuLms.Courses.Lesson do
  @moduledoc """
  Schema for course lessons with multi-tenant support.
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "lessons" do
    field(:title, :string)
    field(:slug, :string)
    field(:description, :string)
    field(:content, :string)
    field(:video_url, :string)
    field(:video_duration_seconds, :integer, default: 0)
    field(:content_type, :string, default: "video")
    field(:position, :integer, default: 0)
    field(:is_published, :boolean, default: false)
    field(:is_free_preview, :boolean, default: false)
    field(:downloadable_resources, :map)

    belongs_to(:tenant, KitabuLms.Tenants.Tenant)
    belongs_to(:module, KitabuLms.Courses.Module)

    has_many(:lesson_progress, KitabuLms.Courses.LessonProgress, on_delete: :delete_all)

    timestamps()
  end

  @doc false
  def changeset(lesson, attrs) do
    lesson
    |> cast(attrs, [
      :title,
      :slug,
      :description,
      :content,
      :video_url,
      :video_duration_seconds,
      :content_type,
      :position,
      :is_published,
      :is_free_preview,
      :downloadable_resources,
      :tenant_id,
      :module_id
    ])
    |> validate_required([:title, :slug])
    |> validate_length(:title, min: 2, max: 200)
    |> validate_length(:slug, min: 2, max: 250)
    |> validate_inclusion(:content_type, ["video", "text", "quiz", "assignment", "live"])
    |> unique_constraint([:module_id, :slug])
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
  Content type values.
  """
  def content_type_values, do: ["video", "text", "quiz", "assignment", "live"]

  @doc """
  Published scope.
  """
  def published(query \\ __MODULE__) do
    from(l in query, where: l.is_published == true)
  end

  @doc """
  Free preview scope.
  """
  def free_preview(query \\ __MODULE__) do
    from(l in query, where: l.is_free_preview == true)
  end

  @doc """
  By module scope.
  """
  def by_module(query \\ __MODULE__, module_id) do
    from(l in query, where: l.module_id == ^module_id)
  end

  @doc """
  Ordered by position.
  """
  def ordered(query \\ __MODULE__) do
    from(l in query, order_by: [asc: l.position])
  end
end
