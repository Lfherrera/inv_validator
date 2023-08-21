defmodule InvValidator.Repo.Migrations.AddingSitesTable do
  use Ecto.Migration

  def change do
    create table(:sites, primary_key: false) do
      add :site_id, :integer, primary_key: true
      add :name, :string

      timestamps()
    end
  end
end
