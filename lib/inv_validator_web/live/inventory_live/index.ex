defmodule InvValidatorWeb.InventoryLive.Index do
  use InvValidatorWeb, :live_view

  alias InvValidator.Validator
  alias InvValidator.Validator.Inventory
  alias InvValidator.Sites

  @impl true
  def mount(_params, _session, socket) do
    socket =  assign(socket,:all_sites, all_sites())
    {:ok, stream(socket, :inventory_collection, Validator.list_inventory())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Inventory")
    |> assign(:inventory, Validator.get_inventory!(id))
    |> assign(:all_sites, all_sites())
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Inventory")
    |> assign(:inventory, %Inventory{})
    |> assign(:all_sites, all_sites())
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Inventory")
    |> assign(:inventory, nil)
    |> assign(:all_sites, all_sites())
  end

  defp all_sites do
      Sites.list_sites()
      |> Enum.map(fn site -> {site.name, site.site_id} end)
  end

  @impl true
  def handle_info({InvValidatorWeb.InventoryLive.FormComponent, {:saved, inventory}}, socket) do
    {:noreply, stream_insert(socket, :inventory_collection, inventory)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    inventory = Validator.get_inventory!(id)
    {:ok, _} = Validator.delete_inventory(inventory)

    {:noreply, stream_delete(socket, :inventory_collection, inventory)}
  end
end
