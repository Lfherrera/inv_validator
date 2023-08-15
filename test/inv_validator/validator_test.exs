defmodule InvValidator.ValidatorTest do
  use InvValidator.DataCase

  alias InvValidator.Validator

  describe "inventory" do
    alias InvValidator.Validator.Inventory

    import InvValidator.ValidatorFixtures

    @invalid_attrs %{date: nil, segment_id: nil, site_id: nil, room_id: nil}

    test "list_inventory/0 returns all inventory" do
      inventory = inventory_fixture()
      assert Validator.list_inventory() == [inventory]
    end

    test "get_inventory!/1 returns the inventory with given id" do
      inventory = inventory_fixture()
      assert Validator.get_inventory!(inventory.id) == inventory
    end

    test "create_inventory/1 with valid data creates a inventory" do
      valid_attrs = %{date: ~D[2023-08-14], segment_id: 42, site_id: 42, room_id: 42}

      assert {:ok, %Inventory{} = inventory} = Validator.create_inventory(valid_attrs)
      assert inventory.date == ~D[2023-08-14]
      assert inventory.segment_id == 42
      assert inventory.site_id == 42
      assert inventory.room_id == 42
    end

    test "create_inventory/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Validator.create_inventory(@invalid_attrs)
    end

    test "update_inventory/2 with valid data updates the inventory" do
      inventory = inventory_fixture()
      update_attrs = %{date: ~D[2023-08-15], segment_id: 43, site_id: 43, room_id: 43}

      assert {:ok, %Inventory{} = inventory} = Validator.update_inventory(inventory, update_attrs)
      assert inventory.date == ~D[2023-08-15]
      assert inventory.segment_id == 43
      assert inventory.site_id == 43
      assert inventory.room_id == 43
    end

    test "update_inventory/2 with invalid data returns error changeset" do
      inventory = inventory_fixture()
      assert {:error, %Ecto.Changeset{}} = Validator.update_inventory(inventory, @invalid_attrs)
      assert inventory == Validator.get_inventory!(inventory.id)
    end

    test "delete_inventory/1 deletes the inventory" do
      inventory = inventory_fixture()
      assert {:ok, %Inventory{}} = Validator.delete_inventory(inventory)
      assert_raise Ecto.NoResultsError, fn -> Validator.get_inventory!(inventory.id) end
    end

    test "change_inventory/1 returns a inventory changeset" do
      inventory = inventory_fixture()
      assert %Ecto.Changeset{} = Validator.change_inventory(inventory)
    end
  end
end
