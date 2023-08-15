defmodule InvValidator.UserSiteAccess do
  @moduledoc """
  The UserSiteAccess context.
  """

  import Ecto.Query, warn: false
  alias InvValidator.Repo

  alias InvValidator.UserSiteAccess.SiteAccess

  @doc """
  Returns the list of user_site_access.

  ## Examples

      iex> list_user_site_access()
      [%SiteAccess{}, ...]

  """
  def list_user_site_access do
    Repo.all(SiteAccess)
  end

  @doc """
  Gets a single site_access.

  Raises `Ecto.NoResultsError` if the Site access does not exist.

  ## Examples

      iex> get_site_access!(123)
      %SiteAccess{}

      iex> get_site_access!(456)
      ** (Ecto.NoResultsError)

  """
  def get_site_access!(id), do: Repo.get!(SiteAccess, id)

  @doc """
  Creates a site_access.

  ## Examples

      iex> create_site_access(%{field: value})
      {:ok, %SiteAccess{}}

      iex> create_site_access(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_site_access(attrs \\ %{}) do
    %SiteAccess{}
    |> SiteAccess.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a site_access.

  ## Examples

      iex> update_site_access(site_access, %{field: new_value})
      {:ok, %SiteAccess{}}

      iex> update_site_access(site_access, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_site_access(%SiteAccess{} = site_access, attrs) do
    site_access
    |> SiteAccess.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a site_access.

  ## Examples

      iex> delete_site_access(site_access)
      {:ok, %SiteAccess{}}

      iex> delete_site_access(site_access)
      {:error, %Ecto.Changeset{}}

  """
  def delete_site_access(%SiteAccess{} = site_access) do
    Repo.delete(site_access)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking site_access changes.

  ## Examples

      iex> change_site_access(site_access)
      %Ecto.Changeset{data: %SiteAccess{}}

  """
  def change_site_access(%SiteAccess{} = site_access, attrs \\ %{}) do
    SiteAccess.changeset(site_access, attrs)
  end
end
