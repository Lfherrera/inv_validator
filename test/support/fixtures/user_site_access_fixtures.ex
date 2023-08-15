defmodule InvValidator.UserSiteAccessFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `InvValidator.UserSiteAccess` context.
  """

  @doc """
  Generate a site_access.
  """
  def site_access_fixture(attrs \\ %{}) do
    {:ok, site_access} =
      attrs
      |> Enum.into(%{
        site_id: 42
      })
      |> InvValidator.UserSiteAccess.create_site_access()

    site_access
  end
end
