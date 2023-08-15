defmodule InvValidator.ValidatorFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `InvValidator.Validator` context.
  """

  @doc """
  Generate a inventory.
  """
  def inventory_fixture(attrs \\ %{}) do
    {:ok, inventory} =
      attrs
      |> Enum.into(%{
        date: ~D[2023-08-14],
        segment_id: 42,
        site_id: 42,
        room_id: 42
      })
      |> InvValidator.Validator.create_inventory()

    inventory
  end
end
