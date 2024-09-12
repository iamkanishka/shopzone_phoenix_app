defmodule Shopzone.Store.Product do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          name: String.t(),
          description: String.t(),
          stock: integer(),
          price: integer(),
          thumbnail: String.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "products" do
    field :name, :string
    field :description, :string
    field :stock, :integer
    field :price, :integer
    field :thumbnail, :string
    timestamps()
  end

  @impl true
  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :stock, :price, :thumnail])
    |> validate_required([:name, :description, :stock, :price, :thumnail])
  end
end
