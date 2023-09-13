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

      <.simple_form for={@form} id="site_access-form" phx-target={@myself} phx-submit="save">
        <%= for {site_name, site_id} <- @available_sites do %>
          <.input
            :if={assigns.action in [:new]}
            value={site_id}
            prompt="Select Site"
            name={site_id}
            type="checkbox"
            label={site_name}
          />
        <% end %>
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

  def handle_event("save", params, socket) do
    user_id = socket.assigns.user_id

    result =
      params
      |> Enum.filter(fn {_site_id, selected} ->
        selected == "true"
      end)
      |> Enum.map(fn {site_id, _seleted} ->
        site_id = String.to_integer(site_id)
        UserSiteAccess.create_site_access(%{site_id: site_id, user_id: user_id})
      end)

    case result |> Enum.filter(fn {error, _} -> error == :error end) do
      [] ->
        notify_parent({:saved, %{}})

        {:noreply,
         socket
         |> put_flash(:info, "Site access created successfully")
         |> push_patch(to: socket.assigns.patch)}

      [{:error, %Ecto.Changeset{} = changeset} | _] ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
