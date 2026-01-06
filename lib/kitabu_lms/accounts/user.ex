defmodule KitabuLms.Accounts.User do
  @moduledoc """
  Schema for users with multi-tenant support and authentication.
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "users" do
    field(:email, :string)
    field(:password, :string, virtual: true)
    field(:password_hash, :string)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:phone, :string)
    field(:avatar_url, :string)
    field(:bio, :string)
    field(:timezone, :string, default: "Africa/Nairobi")
    field(:preferred_locale, :string, default: "en")
    field(:is_email_verified, :boolean, default: false)
    field(:is_active, :boolean, default: true)
    field(:last_sign_in_at, :utc_datetime)
    field(:metadata, :map, default: %{})

    belongs_to(:tenant, KitabuLms.Tenants.Tenant)
    belongs_to(:role, KitabuLms.Accounts.Role)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :email,
      :password,
      :first_name,
      :last_name,
      :phone,
      :avatar_url,
      :bio,
      :timezone,
      :preferred_locale,
      :is_email_verified,
      :is_active,
      :last_sign_in_at,
      :metadata,
      :tenant_id,
      :role_id
    ])
    |> validate_required([:email])
    |> validate_length(:email, min: 5, max: 255)
    |> validate_format(:email, ~r/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/,
      message: "must be a valid email address"
    )
    |> validate_length(:password, min: 8, max: 100)
    |> validate_length(:first_name, max: 100)
    |> validate_length(:last_name, max: 100)
    |> unique_constraint([:tenant_id, :email])
    |> maybe_hash_password()
  end

  defp maybe_hash_password(changeset) do
    password = get_change(changeset, :password)

    if password && changeset.valid? do
      put_change(changeset, :password_hash, Argon2.hash_pwd_salt(password))
    else
      changeset
    end
  end

  @doc """
  Verifies a user's password against the stored hash.
  """
  def verify_password(%__MODULE__{password_hash: hash}, password)
      when is_binary(hash) and is_binary(password) do
    Argon2.verify_pass(password, hash)
  end

  def verify_password(_, _), do: false

  @doc """
  Finds a user by email and tenant.
  """
  def find_by_email(email, tenant_id \\ nil) do
    query =
      from(u in __MODULE__,
        where: u.email == ^email
      )

    if tenant_id do
      query = from(u in query, where: u.tenant_id == ^tenant_id)
      KitabuLms.Repo.one(query)
    else
      KitabuLms.Repo.one(query)
    end
  end

  def full_name(%__MODULE__{first_name: nil, last_name: nil}), do: nil
  def full_name(%__MODULE__{first_name: first_name, last_name: nil}), do: first_name
  def full_name(%__MODULE__{first_name: nil, last_name: last_name}), do: last_name

  def full_name(%__MODULE__{first_name: first_name, last_name: last_name}),
    do: "#{first_name} #{last_name}"
end
