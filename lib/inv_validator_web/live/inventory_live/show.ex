defmodule InvValidatorWeb.InventoryLive.Show do
  use InvValidatorWeb, :live_view

  alias InvValidator.Validator

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:inventory, Validator.get_inventory!(id))}
  end

  defp page_title(:show), do: "Show Inventory"
  defp page_title(:edit), do: "Edit Inventory"
end
