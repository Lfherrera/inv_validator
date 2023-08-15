defmodule InvValidator.UserSiteAccessTest do
  use InvValidator.DataCase

  alias InvValidator.UserSiteAccess

  describe "user_site_access" do
    alias InvValidator.UserSiteAccess.SiteAccess

    import InvValidator.UserSiteAccessFixtures

    @invalid_attrs %{site_id: nil}

    test "list_user_site_access/0 returns all user_site_access" do
      site_access = site_access_fixture()
      assert UserSiteAccess.list_user_site_access() == [site_access]
    end

    test "get_site_access!/1 returns the site_access with given id" do
      site_access = site_access_fixture()
      assert UserSiteAccess.get_site_access!(site_access.id) == site_access
    end

    test "create_site_access/1 with valid data creates a site_access" do
      valid_attrs = %{site_id: 42}

      assert {:ok, %SiteAccess{} = site_access} = UserSiteAccess.create_site_access(valid_attrs)
      assert site_access.site_id == 42
    end

    test "create_site_access/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserSiteAccess.create_site_access(@invalid_attrs)
    end

    test "update_site_access/2 with valid data updates the site_access" do
      site_access = site_access_fixture()
      update_attrs = %{site_id: 43}

      assert {:ok, %SiteAccess{} = site_access} = UserSiteAccess.update_site_access(site_access, update_attrs)
      assert site_access.site_id == 43
    end

    test "update_site_access/2 with invalid data returns error changeset" do
      site_access = site_access_fixture()
      assert {:error, %Ecto.Changeset{}} = UserSiteAccess.update_site_access(site_access, @invalid_attrs)
      assert site_access == UserSiteAccess.get_site_access!(site_access.id)
    end

    test "delete_site_access/1 deletes the site_access" do
      site_access = site_access_fixture()
      assert {:ok, %SiteAccess{}} = UserSiteAccess.delete_site_access(site_access)
      assert_raise Ecto.NoResultsError, fn -> UserSiteAccess.get_site_access!(site_access.id) end
    end

    test "change_site_access/1 returns a site_access changeset" do
      site_access = site_access_fixture()
      assert %Ecto.Changeset{} = UserSiteAccess.change_site_access(site_access)
    end
  end
end
