defmodule InvValidator.Validator.Inventory do
  use Ecto.Schema
  import Ecto.Changeset
  alias InvValidator.Validator.Site

  schema "inventory" do
    field :date, :date
    field :segment_id, :integer
    field :room_id, :integer

    belongs_to :site, Site, references: :site_id

    timestamps()
  end

  @doc false
  def changeset(inventory, attrs) do
    inventory
    |> cast(attrs, [:date, :segment_id, :site_id, :room_id])
    |> validate_required([:date, :segment_id, :site_id, :room_id])
  end
end
