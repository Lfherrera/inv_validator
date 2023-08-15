defmodule InvValidator.Repo.Migrations.CreateUserSiteAccess do
  use Ecto.Migration

  def change do
    create table(:user_site_access) do
      add :site_id, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:user_site_access, [:user_id])
  end
end
