defmodule KitabuLms.Auth do
  @moduledoc """
  Authentication context for user login, registration, and session management.
  """
  import Plug.Conn

  alias KitabuLms.Accounts.User
  alias KitabuLms.Auth.Guardian
  alias KitabuLms.Repo

  @doc """
  Attempts to authenticate a user with email and password.
  Returns {:ok, user, token} on success or {:error, reason} on failure.
  """
  def authenticate(email, password, tenant_id \\ nil) do
    user = User.find_by_email(email, tenant_id)

    cond do
      is_nil(user) ->
        {:error, :invalid_credentials}

      not user.is_active ->
        {:error, :account_inactive}

      User.verify_password(user, password) ->
        {:ok, user, encode_token(user)}

      true ->
        {:error, :invalid_credentials}
    end
  end

  @doc """
  Registers a new user with the given attributes.
  Returns {:ok, user} on success or {:error, changeset} on failure.
  """
  def register_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Generates a JWT token for the given user.
  """
  def encode_token(%User{} = user) do
    {:ok, token, _claims} = Guardian.encode_and_sign(user)
    token
  end

  @doc """
  Gets the current user from the connection or session.
  """
  def current_user(conn) do
    case Guardian.Plug.current_resource(conn) do
      nil -> maybe_fetch_from_session(conn)
      user -> {:ok, user}
    end
  end

  defp maybe_fetch_from_session(conn) do
    user_id = get_session(conn, :current_user_id)

    if user_id do
      case Repo.get(User, user_id) do
        nil -> {:error, :not_found}
        user -> {:ok, user}
      end
    else
      {:error, :not_authenticated}
    end
  end

  @doc """
  Logs out the current user.
  """
  def log_out(conn) do
    Guardian.Plug.sign_out(conn)
  end

  @doc """
  Checks if the current user has a specific permission.
  """
  def has_permission(%User{} = user, permission) do
    if user.role do
      permissions = user.role.permissions || %{}

      get_in(permissions, [permission]) == :read or
        get_in(permissions, [permission]) == :write or
        get_in(permissions, [permission]) == :manage or
        permissions[permission] == true
    else
      false
    end
  end

  @doc """
  Checks if the user has a specific role.
  """
  def has_role?(%User{} = user, role_slug) do
    user.role && user.role.slug == role_slug
  end

  @doc """
  Checks if the user is an admin.
  """
  def admin?(%User{} = user), do: has_role?(user, "admin")

  @doc """
  Checks if the user is an instructor.
  """
  def instructor?(%User{} = user), do: has_role?(user, "instructor")

  @doc """
  Checks if the user is a student.
  """
  def student?(%User{} = user), do: has_role?(user, "student")
end
