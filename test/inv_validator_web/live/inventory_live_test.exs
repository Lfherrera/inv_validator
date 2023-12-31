defmodule InvValidatorWeb.InventoryLiveTest do
  use InvValidatorWeb.ConnCase

  import Phoenix.LiveViewTest
  import InvValidator.ValidatorFixtures

  @create_attrs %{date: "2023-08-14", segment_id: 42, site_id: 42, room_id: 42}
  @update_attrs %{date: "2023-08-15", segment_id: 43, site_id: 43, room_id: 43}
  @invalid_attrs %{date: nil, segment_id: nil, site_id: nil, room_id: nil}

  defp create_inventory(_) do
    inventory = inventory_fixture()
    %{inventory: inventory}
  end

  describe "Index" do
    setup [:create_inventory]

    test "lists all inventory", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/inventory")

      assert html =~ "Listing Inventory"
    end

    test "saves new inventory", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/inventory")

      assert index_live |> element("a", "New Inventory") |> render_click() =~
               "New Inventory"

      assert_patch(index_live, ~p"/inventory/new")

      assert index_live
             |> form("#inventory-form", inventory: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#inventory-form", inventory: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/inventory")

      html = render(index_live)
      assert html =~ "Inventory created successfully"
    end

    test "updates inventory in listing", %{conn: conn, inventory: inventory} do
      {:ok, index_live, _html} = live(conn, ~p"/inventory")

      assert index_live |> element("#inventory-#{inventory.id} a", "Edit") |> render_click() =~
               "Edit Inventory"

      assert_patch(index_live, ~p"/inventory/#{inventory}/edit")

      assert index_live
             |> form("#inventory-form", inventory: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#inventory-form", inventory: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/inventory")

      html = render(index_live)
      assert html =~ "Inventory updated successfully"
    end

    test "deletes inventory in listing", %{conn: conn, inventory: inventory} do
      {:ok, index_live, _html} = live(conn, ~p"/inventory")

      assert index_live |> element("#inventory-#{inventory.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#inventory-#{inventory.id}")
    end
  end

  describe "Show" do
    setup [:create_inventory]

    test "displays inventory", %{conn: conn, inventory: inventory} do
      {:ok, _show_live, html} = live(conn, ~p"/inventory/#{inventory}")

      assert html =~ "Show Inventory"
    end

    test "updates inventory within modal", %{conn: conn, inventory: inventory} do
      {:ok, show_live, _html} = live(conn, ~p"/inventory/#{inventory}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Inventory"

      assert_patch(show_live, ~p"/inventory/#{inventory}/show/edit")

      assert show_live
             |> form("#inventory-form", inventory: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#inventory-form", inventory: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/inventory/#{inventory}")

      html = render(show_live)
      assert html =~ "Inventory updated successfully"
    end
  end
end
