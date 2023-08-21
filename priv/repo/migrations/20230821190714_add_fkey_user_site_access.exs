defmodule InvValidator.Repo.Migrations.AddFkeyUserSiteAccess do
  use Ecto.Migration

  def change do
    alter table(:user_site_access) do
      remove :site_id
      add :site_id, references(:sites, on_delete: :nothing, column: :site_id)
    end
  end
end
