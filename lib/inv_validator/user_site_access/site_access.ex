defmodule InvValidator.UserSiteAccess.SiteAccess do
  use Ecto.Schema
  import Ecto.Changeset
  alias InvValidator.Users.User
  alias InvValidator.Validator.Site

  schema "user_site_access" do
    belongs_to :user, User
    belongs_to :site, Site, references: :site_id

    timestamps()
  end

  @spec changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  @doc false
  def changeset(site_access, attrs) do
    site_access
    |> cast(attrs, [:site_id, :user_id])
    |> validate_required([:site_id])
  end
end
