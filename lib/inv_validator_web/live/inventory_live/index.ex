defmodule InvValidatorWeb.InventoryLive.Index do
  use InvValidatorWeb, :live_view

  alias InvValidator.Validator
  alias InvValidator.Validator.Inventory
  alias InvValidator.Sites
  alias Phoenix.PubSub

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, :all_sites, all_sites())

    if connected?(socket) do
      PubSub.subscribe(InvValidator.PubSub, "inventory_checked_result")
    end

    {:ok, assign(socket, :inventory_collection, list_inventory())}
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

  defp list_inventory do
    Validator.list_inventory()
    |> Enum.map(fn i -> Map.put(i, :occupied, false) end)
  end

  @impl true
  def handle_info({InvValidatorWeb.InventoryLive.FormComponent, {:saved, inventory}}, socket) do
    PubSub.broadcast(InvValidator.PubSub, "inventory_to_check", inventory)
    IO.inspect(inventory, label: "PARENT HADNLING SAVE")
    {:noreply, socket}
  end

  def handle_info(%{site_id: site_id, room_id: room_id, occupied: occupied} = msg, socket) do
    IO.inspect(msg, label: "WE GOT THE MESSAGE FROM TSW CHECKER!!")
    invs = socket.assigns.inventory_collection

    inv =
      if Enum.any?(invs, fn i -> i.room_id == room_id and i.site_id == site_id end) do
        invs |> IO.inspect(label: "EXISTS ******")
      else
        new = Validator.get_by!(room_id: room_id, site_id: site_id)
        (invs ++ [new]) |> IO.inspect(label: "NEW ******")
      end

    updated =
      inv
      |> Enum.map(fn i ->
        if i.room_id == room_id and i.site_id == site_id do
          IO.inspect(i, label: "XXXX WOW WOWO XXXXX")
          Map.put(i, :occupied, occupied)
        else
          i
        end
      end)

    {:noreply, assign(socket, :inventory_collection, updated)}
  end

  @impl true
  def handle_event("delete", %{"site_id" => site_id, "room_id" => room_id, "date" => date}, socket) do
    inventory = Validator.get_by!(site_id: site_id, room_id: room_id, date: date)
    {:ok, _} = Validator.delete_inventory(inventory)

    inv =
      socket.assigns.inventory_collection
      |> Enum.reject(fn i ->
        i.room_id == inventory.room_id and i.site_id == site_id and i.date == date
      end)

    {:noreply, assign(socket, :inventory_collection, inv)}
  end
end
