defmodule KitabuLms.Tenants.Tenant do
  @moduledoc """
  Schema for multi-tenant organizations.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "tenants" do
    field(:name, :string)
    field(:slug, :string)
    field(:domain, :string)
    field(:logo_url, :string)
    field(:primary_color, :string, default: "#00af91")
    field(:secondary_color, :string, default: "#ffc300")
    field(:settings, :map, default: %{})
    field(:is_active, :boolean, default: true)
    field(:subscription_tier, :string, default: "free")
    field(:subscription_expires_at, :utc_datetime)

    timestamps()
  end

  @doc false
  def changeset(tenant, attrs) do
    tenant
    |> cast(attrs, [
      :name,
      :slug,
      :domain,
      :logo_url,
      :primary_color,
      :secondary_color,
      :settings,
      :is_active,
      :subscription_tier,
      :subscription_expires_at
    ])
    |> validate_required([:name, :slug])
    |> validate_length(:name, min: 2, max: 255)
    |> validate_length(:slug, min: 2, max: 100)
    |> validate_format(:slug, ~r/^[a-z0-9-]+$/,
      message: "only allows lowercase letters, numbers, and hyphens"
    )
    |> unique_constraint(:slug)
    |> unique_constraint(:domain)
  end
end
