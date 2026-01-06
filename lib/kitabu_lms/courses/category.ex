defmodule KitabuLms.Courses.Category do
  @moduledoc """
  Schema for course categories with multi-tenant support.
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "categories" do
    field(:name, :string)
    field(:slug, :string)
    field(:description, :string)
    field(:icon, :string)
    field(:color, :string)
    field(:is_active, :boolean, default: true)
    field(:course_count, :integer, default: 0)

    belongs_to(:tenant, KitabuLms.Tenants.Tenant)
    belongs_to(:parent, KitabuLms.Courses.Category)

    has_many(:children, KitabuLms.Courses.Category, foreign_key: :parent_id)
    has_many(:courses, KitabuLms.Courses.Course)

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [
      :name,
      :slug,
      :description,
      :icon,
      :color,
      :is_active,
      :course_count,
      :tenant_id,
      :parent_id
    ])
    |> validate_required([:name, :slug])
    |> validate_length(:name, min: 2, max: 100)
    |> validate_length(:slug, min: 2, max: 100)
    |> unique_constraint([:tenant_id, :slug])
    |> generate_slug()
  end

  defp generate_slug(changeset) do
    name = get_change(changeset, :name)

    if name do
      slug =
        name
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
  Active scope.
  """
  def active(query \\ __MODULE__) do
    from(c in query, where: c.is_active == true)
  end

  @doc """
  By tenant scope.
  """
  def by_tenant(query \\ __MODULE__, tenant_id) do
    from(c in query, where: c.tenant_id == ^tenant_id)
  end

  @doc """
  Root categories (no parent).
  """
  def root(query \\ __MODULE__) do
    from(c in query, where: is_nil(c.parent_id))
  end

  @doc """
  Children of a category.
  """
  def children_of(query \\ __MODULE__, parent_id) do
    from(c in query, where: c.parent_id == ^parent_id)
  end
end
