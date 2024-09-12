defmodule Shopzone.Store.CartItem do
  alias Shopzone.Store.Product

  use Ecto.Schema
  import Ecto.Changeset

  schema "cart_items" do
    field :cart_id, :id
    field :quantity, :integer
    belongs_to :product, Product
    timestamps()
  end

  @impl true
  @doc false
  def changeset(cart_items, attrs) do
    cart_items
    |> cast(attrs, [:quntity])
    |> validate_required([:quntity])
  end
end
