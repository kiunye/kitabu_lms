defmodule KitabuLms.Courses.Course do
  @moduledoc """
  Schema for courses with multi-tenant support.
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "courses" do
    field(:title, :string)
    field(:slug, :string)
    field(:description, :string)
    field(:short_description, :string)
    field(:thumbnail_url, :string)
    field(:preview_video_url, :string)
    field(:level, :string, default: "beginner")
    field(:language, :string, default: "en")
    field(:duration_hours, :integer, default: 0)
    field(:price, :integer, default: 0)
    field(:original_price, :integer)
    field(:currency, :string, default: "USD")
    field(:is_published, :boolean, default: false)
    field(:is_featured, :boolean, default: false)
    field(:is_free, :boolean, default: false)
    field(:enrollment_count, :integer, default: 0)
    field(:rating, :decimal)
    field(:rating_count, :integer, default: 0)
    field(:metadata, :map)
    field(:published_at, :utc_datetime)

    belongs_to(:tenant, KitabuLms.Tenants.Tenant)
    belongs_to(:instructor, KitabuLms.Instructors.Instructor)
    belongs_to(:category, KitabuLms.Courses.Category)

    has_many(:modules, KitabuLms.Courses.Module, on_delete: :delete_all)
    has_many(:lessons, through: [:modules, :lessons])
    has_many(:enrollments, KitabuLms.Courses.Enrollment)
    has_many(:order_items, KitabuLms.Orders.OrderItem)

    timestamps()
  end

  @doc false
  def changeset(course, attrs) do
    course
    |> cast(attrs, [
      :title,
      :slug,
      :description,
      :short_description,
      :thumbnail_url,
      :preview_video_url,
      :level,
      :language,
      :duration_hours,
      :price,
      :original_price,
      :currency,
      :is_published,
      :is_featured,
      :is_free,
      :enrollment_count,
      :rating,
      :rating_count,
      :metadata,
      :published_at,
      :tenant_id,
      :instructor_id,
      :category_id
    ])
    |> validate_required([:title, :slug])
    |> validate_length(:title, min: 3, max: 200)
    |> validate_length(:slug, min: 3, max: 250)
    |> unique_constraint([:tenant_id, :slug])
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
  Level values.
  """
  def level_values, do: ["beginner", "intermediate", "advanced", "all"]

  @doc """
  Publishes a course.
  """
  def publish(course) do
    change(course, %{is_published: true, published_at: DateTime.utc_now()})
  end

  @doc """
  Unpublishes a course.
  """
  def unpublish(course) do
    change(course, %{is_published: false})
  end

  @doc """
  Increments enrollment count.
  """
  def increment_enrollment(course) do
    change(course, %{enrollment_count: course.enrollment_count + 1})
  end

  @doc """
  Updates rating.
  """
  def update_rating(course, new_rating) do
    current_rating = course.rating || Decimal.new("0")
    current_count = course.rating_count || 0

    new_count = current_count + 1

    new_rating_value =
      Decimal.add(current_rating, new_rating) |> Decimal.div(new_count) |> Decimal.round(2)

    change(course, %{rating: new_rating_value, rating_count: new_count})
  end

  @doc """
  Published scope.
  """
  def published(query \\ __MODULE__) do
    from(c in query, where: c.is_published == true)
  end

  @doc """
  Featured scope.
  """
  def featured(query \\ __MODULE__) do
    from(c in query, where: c.is_featured == true)
  end

  @doc """
  By category scope.
  """
  def by_category(query \\ __MODULE__, category_id) do
    from(c in query, where: c.category_id == ^category_id)
  end

  @doc """
  By instructor scope.
  """
  def by_instructor(query \\ __MODULE__, instructor_id) do
    from(c in query, where: c.instructor_id == ^instructor_id)
  end

  @doc """
  By tenant scope.
  """
  def by_tenant(query \\ __MODULE__, tenant_id) do
    from(c in query, where: c.tenant_id == ^tenant_id)
  end
end
