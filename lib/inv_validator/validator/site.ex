defmodule InvValidator.Validator.Site do
  use Ecto.Schema
  import Ecto.Changeset
  @primary_key false
  schema "sites" do
    field :site_id, :integer, primary_key: true
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(site, attrs) do
    site
    |> cast(attrs, [:site_id, :name])
    |> validate_required([:site_id, :name])
    |> unique_constraint(:site_id, message: "Site Id already exist", name: "sites_pkey")
  end

  #   {:error,
  #  #Ecto.Changeset<
  #    action: :insert,
  #    changes: %{name: "Vallarta", site_id: 2},
  #    errors: [
  #      site_id: {"Site Id already exist",
  #       [constraint: :unique, constraint_name: "sites_pkey"]}
  #    ],
  #    data: #InvValidator.Validator.Site<>,
  #    valid?: false
  #  >}
end
