defmodule InvValidatorWeb.InventoryLive.FormComponent do
  use InvValidatorWeb, :live_component

  alias InvValidator.Validator

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage inventory records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="inventory-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:date]} type="date" label="Date" />
        <.input field={@form[:segment_id]} type="number" label="Segment" />
        <.input
          :if={assigns.action in [:new, :edit]}
          options={@all_sites}
          value={@form[:site_id].value}
          prompt="Select Site"
          name="selected_site"
          type="select"
          label="Site"
        />
        <.input field={@form[:site_id]} type="hidden" />
        <.input field={@form[:room_id]} type="number" label="Room" />

        <:actions>
          <.button phx-disable-with="Saving...">Save Inventory</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{inventory: inventory} = assigns, socket) do
    changeset = Validator.change_inventory(inventory)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"inventory" => inventory_params} = params, socket) do
    changeset =
      socket.assigns.inventory
      |> Validator.change_inventory(append_site_id(inventory_params, params["selected_site"]))
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event(
        "save",
        %{"inventory" => inventory_params, "selected_site" => selected_site_id},
        socket
      ) do
    save_inventory(
      socket,
      socket.assigns.action,
      append_site_id(inventory_params, selected_site_id)
    )
  end

  defp append_site_id(inventory_params, selected_site_id) do
    if selected_site_id == "" || selected_site_id == nil do
      inventory_params
    else
      %{inventory_params | "site_id" => selected_site_id}
    end
  end

  defp save_inventory(socket, :edit, inventory_params) do
    case Validator.update_inventory(socket.assigns.inventory, inventory_params) do
      {:ok, inventory} ->
        notify_parent({:saved, inventory})

        {:noreply,
         socket
         |> put_flash(:info, "Inventory updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_inventory(socket, :new, inventory_params) do
    case Validator.create_inventory(inventory_params) do
      {:ok, inventory} ->
        notify_parent({:saved, inventory})

        {:noreply,
         socket
         |> put_flash(:info, "Inventory created successfully")
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
