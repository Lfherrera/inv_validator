defmodule InvValidator.Validator do
  @moduledoc """
  The Validator context.
  """

  import Ecto.Query, warn: false
  alias InvValidator.Repo

  alias InvValidator.Validator.Inventory

  @doc """
  Returns the list of inventory.

  ## Examples

      iex> list_inventory()
      [%Inventory{}, ...]

  """
  def list_inventory do
    Repo.all(from i in Inventory, preload: :site)
  end

  @doc """

  comments_query = from c in Comment, order_by: c.published_at
  Repo.all from p in Post, preload: [comments: ^comments_query]

  Gets a single inventory.

  Raises `Ecto.NoResultsError` if the Inventory does not exist.

  ## Examples

      iex> get_inventory!(123)
      %Inventory{}

      iex> get_inventory!(456)
      ** (Ecto.NoResultsError)

  """
  def get_inventory!(id), do: Repo.get!(from( i in Inventory, preload: :site), id)

  @doc """
  Creates a inventory.

  ## Examples

      iex> create_inventory(%{field: value})
      {:ok, %Inventory{}}

      iex> create_inventory(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_inventory(attrs \\ %{}) do
     %Inventory{}
    |> Inventory.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, inventory} -> {:ok, Repo.preload(inventory, :site) }
      other -> other
    end
  end

  @doc """
  Updates a inventory.

  ## Examples

      iex> update_inventory(inventory, %{field: new_value})
      {:ok, %Inventory{}}

      iex> update_inventory(inventory, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_inventory(%Inventory{} = inventory, attrs) do
    inventory
    |> Inventory.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a inventory.

  ## Examples

      iex> delete_inventory(inventory)
      {:ok, %Inventory{}}

      iex> delete_inventory(inventory)
      {:error, %Ecto.Changeset{}}

  """
  def delete_inventory(%Inventory{} = inventory) do
    Repo.delete(inventory)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking inventory changes.

  ## Examples

      iex> change_inventory(inventory)
      %Ecto.Changeset{data: %Inventory{}}

  """
  def change_inventory(%Inventory{} = inventory, attrs \\ %{}) do
    Inventory.changeset(inventory, attrs)
  end
end
