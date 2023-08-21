defmodule InvValidator.Repo.Migrations.AddFkeySiteIDonInventory do
  use Ecto.Migration

  def change do
    alter table(:inventory) do
      remove :site_id
      add :site_id, references(:sites, on_delete: :nothing, column: :site_id)
    end
  end
end
