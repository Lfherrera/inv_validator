defmodule InvValidatorWeb.SiteAccessLive.FormComponent do
  use InvValidatorWeb, :live_component

  alias InvValidator.UserSiteAccess

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage site_access records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="site_access-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:site_id]} type="number" label="Site" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Site access</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{site_access: site_access} = assigns, socket) do
    changeset = UserSiteAccess.change_site_access(site_access)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"site_access" => site_access_params}, socket) do
    changeset =
      socket.assigns.site_access
      |> UserSiteAccess.change_site_access(site_access_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"site_access" => site_access_params}, socket) do
    save_site_access(socket, socket.assigns.action, site_access_params)
  end

  defp save_site_access(socket, :edit, site_access_params) do
    case UserSiteAccess.update_site_access(socket.assigns.site_access, site_access_params) do
      {:ok, site_access} ->
        notify_parent({:saved, site_access})

        {:noreply,
         socket
         |> put_flash(:info, "Site access updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_site_access(socket, :new, site_access_params) do
    case UserSiteAccess.create_site_access(site_access_params) do
      {:ok, site_access} ->
        notify_parent({:saved, site_access})

        {:noreply,
         socket
         |> put_flash(:info, "Site access created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
