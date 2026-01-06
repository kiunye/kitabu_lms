defmodule KitabuLms.Instructors.Instructor do
  @moduledoc """
  Schema for course instructors.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "instructors" do
    field(:slug, :string)
    field(:title, :string)
    field(:specialization, :string)
    field(:headline, :string)
    field(:bio, :string)
    field(:avatar_url, :string)
    field(:cover_image_url, :string)
    field(:website_url, :string)
    field(:twitter_handle, :string)
    field(:linkedin_url, :string)
    field(:youtube_url, :string)
    field(:years_of_experience, :integer, default: 0)
    field(:total_students, :integer, default: 0)
    field(:total_courses, :integer, default: 0)
    field(:average_rating, :decimal, default: Decimal.new("0.00"))
    field(:is_verified, :boolean, default: false)
    field(:is_active, :boolean, default: true)
    field(:metadata, :map, default: %{})

    belongs_to(:tenant, KitabuLms.Tenants.Tenant)
    belongs_to(:user, KitabuLms.Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(instructor, attrs) do
    instructor
    |> cast(attrs, [
      :slug,
      :title,
      :specialization,
      :headline,
      :bio,
      :avatar_url,
      :cover_image_url,
      :website_url,
      :twitter_handle,
      :linkedin_url,
      :youtube_url,
      :years_of_experience,
      :total_students,
      :total_courses,
      :average_rating,
      :is_verified,
      :is_active,
      :metadata,
      :tenant_id,
      :user_id
    ])
    |> validate_required([:slug, :tenant_id])
    |> validate_length(:slug, min: 2, max: 100)
    |> validate_format(:slug, ~r/^[a-z0-9-]+$/,
      message: "only allows lowercase letters, numbers, and hyphens"
    )
    |> validate_length(:title, max: 200)
    |> validate_length(:headline, max: 255)
    |> unique_constraint([:tenant_id, :slug])
  end
end
