defmodule InvValidator.UserSiteAccess.SiteAccess do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_site_access" do
    field :site_id, :integer
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(site_access, attrs) do
    site_access
    |> cast(attrs, [:site_id])
    |> validate_required([:site_id])
  end
end
