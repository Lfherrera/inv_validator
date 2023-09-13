defmodule InvValidator.Sites do
  @moduledoc """
  The Sites context.
  """

  import Ecto.Query, warn: false
  alias InvValidator.Repo
  alias InvValidator.Validator.Site

  def list_sites do
    Repo.all(Site)
  end

  def get_site!(id), do: Repo.get!(Site, id)

  def create_site(attrs \\ %{}) do
    %Site{}
    |> Site.changeset(attrs)
    |> Repo.insert()
  end

  def update_site(%Site{} = site, attrs) do
    site
    |> Site.changeset(attrs)
    |> Repo.update()
  end

  def delete_site(%Site{} = site) do
    Repo.delete(site)
  end

  def change_site(%Site{} = site, attrs \\ %{}) do
    Site.changeset(site, attrs)
  end
end
