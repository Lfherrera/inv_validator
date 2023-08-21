defmodule InvValidatorWeb.SiteAccessLive.Index do
  use InvValidatorWeb, :live_view

  alias InvValidator.UserSiteAccess
  alias InvValidator.UserSiteAccess.SiteAccess

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :user_site_access, UserSiteAccess.list_user_site_access())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Site access")
    |> assign(:site_access, UserSiteAccess.get_site_access!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Site access")
    |> assign(:site_access, %SiteAccess{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing User site access")
    |> assign(:site_access, nil)
  end

  @impl true
  def handle_info({InvValidatorWeb.SiteAccessLive.FormComponent, {:saved, site_access}}, socket) do
    {:noreply, stream_insert(socket, :user_site_access, site_access)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    site_access = UserSiteAccess.get_site_access!(id)
    {:ok, _} = UserSiteAccess.delete_site_access(site_access)

    {:noreply, stream_delete(socket, :user_site_access, site_access)}
  end
end
