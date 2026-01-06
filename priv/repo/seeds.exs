# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     KitabuLms.Repo.insert!(%KitabuLms.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias KitabuLms.Repo
alias KitabuLms.Tenants.Tenant
alias KitabuLms.Accounts.Role

IO.puts("Seeding database...")

# Create default tenant
default_tenant =
  case Repo.get_by(Tenant, slug: "kitabu") do
    nil ->
      {:ok, tenant} =
        %Tenant{}
        |> Tenant.changeset(%{
          name: "Kitabu LMS",
          slug: "kitabu",
          domain: "kitabu.com",
          primary_color: "#00af91",
          secondary_color: "#ffc300",
          is_active: true,
          subscription_tier: "enterprise"
        })
        |> Repo.insert()

      IO.puts("Created default tenant: #{tenant.name}")
      tenant

    tenant ->
      IO.puts("Using existing tenant: #{tenant.name}")
      tenant
  end

# Define permissions for each role
admin_permissions = %{
  users: [:read, :write, :delete, :manage],
  courses: [:read, :write, :delete, :manage],
  instructors: [:read, :write, :delete, :manage],
  students: [:read, :write, :delete, :manage],
  content: [:read, :write, :delete, :manage],
  settings: [:read, :write],
  analytics: [:read, :export],
  billing: [:read, :write]
}

instructor_permissions = %{
  courses: [:read, :write, :delete],
  content: [:read, :write, :delete],
  students: [:read, :manage],
  analytics: [:read]
}

student_permissions = %{
  courses: [:read, :enroll],
  content: [:read],
  progress: [:write]
}

# Create roles
roles = [
  %{
    name: "Administrator",
    slug: "admin",
    description: "Full access to all features and settings",
    permissions: admin_permissions,
    is_system: true
  },
  %{
    name: "Instructor",
    slug: "instructor",
    description: "Can create and manage courses and view analytics",
    permissions: instructor_permissions,
    is_system: true
  },
  %{
    name: "Student",
    slug: "student",
    description: "Can enroll in courses and track progress",
    permissions: student_permissions,
    is_system: true
  }
]

Enum.each(roles, fn role_attrs ->
  case Repo.get_by(Role, slug: role_attrs.slug) do
    nil ->
      {:ok, role} =
        %Role{}
        |> Role.changeset(role_attrs)
        |> Repo.insert()

      IO.puts("Created role: #{role.name}")

    role ->
      IO.puts("Using existing role: #{role.name}")
  end
end)

IO.puts("Seeding complete!")
