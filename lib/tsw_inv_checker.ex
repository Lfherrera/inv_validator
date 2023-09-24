defmodule InvValidator.TswInvChecker do
  use GenServer

  alias InvValidator.Validator.Inventory
  alias Phoenix.PubSub

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: :tsw_checker)
  end

  @impl true
  def init(init_arg) do
    Process.send_after(self(), :subscribe, 100)
    {:ok, init_arg}
  end

  def check_unit_now(%Inventory{} = inv) do
    GenServer.call(:tsw_checker, {:check, inv})
  end

  @impl true
  def handle_call({:check, inv}, _, state) do
    {:reply, check(inv), state}
  end

  @impl true
  def handle_info(%Inventory{} = inv, state) do
    IO.inspect(inv, label: "****** TSW")
    PubSub.broadcast!(InvValidator.PubSub, "inventory_checked_result", check(inv))
    {:noreply, state}
  end

  def handle_info(:subscribe, state) do
    subscribe() |> IO.inspect(label: "DEBUGG")
    {:noreply, state}
  end

  def handle_info(other, state) do
    other |> IO.inspect(label: "OTHER")
    {:noreply, state}
  end

  defp subscribe do
    PubSub.subscribe(InvValidator.PubSub, "inventory_to_check")
  end

  defp check(inv) do
    %{site_id: inv.site_id, room_id: inv.room_id, occupied: Enum.random([false, true])}
  end
end
