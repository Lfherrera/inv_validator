defmodule InvValidatorWeb.SiteAccessLive.Index do
  use InvValidatorWeb, :live_view

  alias InvValidator.UserSiteAccess
  alias InvValidator.UserSiteAccess.SiteAccess
  alias InvValidator.Sites

  @impl true
  def mount(_params, _session, socket) do
    access = UserSiteAccess.list_user_site_access()
    by_user = by_user(access)

    {:ok, socket |> assign(by_user: by_user, available_sites: [], user_id: nil)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, %{"user_id" => user_id}) do
    assigned_sites_id =
      UserSiteAccess.get_site_access_by_user_id(user_id)
      |> Enum.map(fn r -> r.site_id end)

    available_sites =
      Sites.list_sites()
      |> Enum.reject(fn s ->
        Enum.member?(assigned_sites_id, s.site_id)
      end)
      |> Enum.map(fn s -> {s.name, s.site_id} end)
      |> IO.inspect()

    socket
    |> assign(:page_title, "New Site access")
    |> assign(:site_access, %SiteAccess{})
    |> assign(:available_sites, available_sites)
    |> assign(:user_id, user_id)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing User site access")
    |> assign(:site_access, nil)
  end

  @impl true
  def handle_info({InvValidatorWeb.SiteAccessLive.FormComponent, {:saved, _site_access}}, socket) do
    access = UserSiteAccess.list_user_site_access()
    by_user = by_user(access)

    {:noreply, socket |> assign(by_user: by_user)}
  end

  @impl true
  def handle_event("delete", %{"user_id" => user_id, "site_id" => site_id}, socket) do
    site_access = UserSiteAccess.get_site_access!(user_id, site_id)
    {:ok, _} = UserSiteAccess.delete_site_access(site_access)

    access = UserSiteAccess.list_user_site_access()
    by_user = by_user(access)

    {:noreply, socket |> assign(by_user: by_user)}
  end

  defp by_user(site_accesses) do
    site_accesses
    |> Enum.group_by(fn r -> r.user.email end)
    |> Enum.map(fn {_email, records} ->
      sites = records |> Enum.map(fn r -> r.site end) |> Enum.sort_by(fn r -> r.name end)
      site_access = records |> List.first()
      %{user: site_access.user, sites: sites}
    end)
  end
end
