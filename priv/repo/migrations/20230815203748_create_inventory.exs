defmodule InvValidator.Repo.Migrations.CreateInventory do
  use Ecto.Migration

  def change do
    create table(:inventory) do
      add :date, :date
      add :segment_id, :integer
      add :site_id, :integer
      add :room_id, :integer

      timestamps()
    end
  end
end
