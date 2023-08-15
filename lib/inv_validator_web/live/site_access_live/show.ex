defmodule InvValidatorWeb.SiteAccessLive.Show do
  use InvValidatorWeb, :live_view

  alias InvValidator.UserSiteAccess

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:site_access, UserSiteAccess.get_site_access!(id))}
  end

  defp page_title(:show), do: "Show Site access"
  defp page_title(:edit), do: "Edit Site access"
end
