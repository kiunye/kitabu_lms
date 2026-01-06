defmodule KitabuLms.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:tenant_id, references(:tenants, type: :binary_id, on_delete: :nothing))
      add(:role_id, references(:roles, type: :binary_id, on_delete: :nothing))
      add(:email, :string, null: false)
      add(:password_hash, :string)
      add(:first_name, :string)
      add(:last_name, :string)
      add(:phone, :string)
      add(:avatar_url, :string)
      add(:bio, :text)
      add(:timezone, :string, default: "Africa/Nairobi")
      add(:preferred_locale, :string, default: "en")
      add(:is_email_verified, :boolean, default: false)
      add(:is_active, :boolean, default: true)
      add(:last_sign_in_at, :utc_datetime)
      add(:metadata, :map, default: %{})
      add(:inserted_at, :utc_datetime, null: false, default: fragment("now()"))
      add(:updated_at, :utc_datetime, null: false, default: fragment("now()"))
    end

    create(index(:users, [:tenant_id]))
    create(index(:users, [:role_id]))
    create(unique_index(:users, [:tenant_id, :email]))
    create(index(:users, [:is_active]))
    create(index(:users, [:last_sign_in_at]))

    create(
      constraint(:users, :email_format,
        check: "email ~* '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$'"
      )
    )
  end
end
