defmodule KitabuLms.Repo.Migrations.CreateOauthProviders do
  use Ecto.Migration

  def change do
    create table(:oauth_providers, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:user_id, references(:users, on_delete: :delete_all, type: :binary_id))
      add(:provider, :string, null: false)
      add(:provider_uid, :string, null: false)
      add(:email, :string)
      add(:name, :string)
      add(:avatar_url, :string)
      add(:access_token, :string)
      add(:refresh_token, :string)
      add(:token_expires_at, :utc_datetime)
      add(:inserted_at, :utc_datetime, null: false)
      add(:updated_at, :utc_datetime, null: false)
    end

    create(unique_index(:oauth_providers, [:provider, :provider_uid]))
    create(index(:oauth_providers, [:user_id]))
  end
end
