defmodule KitabuLms.Accounts.Role do
  @moduledoc """
  Schema for user roles with permissions.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "roles" do
    field(:name, :string)
    field(:slug, :string)
    field(:description, :string)
    field(:permissions, :map, default: %{})
    field(:is_system, :boolean, default: false)

    timestamps()
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name, :slug, :description, :permissions, :is_system])
    |> validate_required([:name, :slug])
    |> validate_length(:name, min: 2, max: 100)
    |> validate_length(:slug, min: 2, max: 50)
    |> validate_format(:slug, ~r/^[a-z0-9_]+$/,
      message: "only allows lowercase letters, numbers, and underscores"
    )
    |> unique_constraint(:slug)
  end
end
