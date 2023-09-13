defmodule InvValidatorWeb.SiteAccessLiveTest do
  use InvValidatorWeb.ConnCase

  import Phoenix.LiveViewTest
  import InvValidator.UserSiteAccessFixtures

  @create_attrs %{site_id: 42}
  @update_attrs %{site_id: 43}
  @invalid_attrs %{site_id: nil}

  defp create_site_access(_) do
    site_access = site_access_fixture()
    %{site_access: site_access}
  end

  describe "Index" do
    setup [:create_site_access]

    test "lists all user_site_access", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/access")

      assert html =~ "Listing User site access"
    end

    test "saves new site_access", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/access")

      assert index_live |> element("a", "New Site access") |> render_click() =~
               "New Site access"

      assert_patch(index_live, ~p"/access/new")

      assert index_live
             |> form("#site_access-form", site_access: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#site_access-form", site_access: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/access")

      html = render(index_live)
      assert html =~ "Site access created successfully"
    end

    test "updates site_access in listing", %{conn: conn, site_access: site_access} do
      {:ok, index_live, _html} = live(conn, ~p"/access")

      assert index_live
             |> element("#user_site_access-#{site_access.id} a", "Edit")
             |> render_click() =~
               "Edit Site access"

      assert_patch(index_live, ~p"/access/#{site_access}/edit")

      assert index_live
             |> form("#site_access-form", site_access: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#site_access-form", site_access: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/access")

      html = render(index_live)
      assert html =~ "Site access updated successfully"
    end

    test "deletes site_access in listing", %{conn: conn, site_access: site_access} do
      {:ok, index_live, _html} = live(conn, ~p"/access")

      assert index_live
             |> element("#user_site_access-#{site_access.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#user_site_access-#{site_access.id}")
    end
  end

  describe "Show" do
    setup [:create_site_access]

    test "displays site_access", %{conn: conn, site_access: site_access} do
      {:ok, _show_live, html} = live(conn, ~p"/access/#{site_access}")

      assert html =~ "Show Site access"
    end

    test "updates site_access within modal", %{conn: conn, site_access: site_access} do
      {:ok, show_live, _html} = live(conn, ~p"/access/#{site_access}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Site access"

      assert_patch(show_live, ~p"/access/#{site_access}/show/edit")

      assert show_live
             |> form("#site_access-form", site_access: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#site_access-form", site_access: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/access/#{site_access}")

      html = render(show_live)
      assert html =~ "Site access updated successfully"
    end
  end
end
