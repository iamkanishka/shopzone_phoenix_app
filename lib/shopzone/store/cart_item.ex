defmodule Shopzone.Store.CartItem do

  use Ecto.Schema
  import Ecto.Changeset


  schema "cart_items" do
    field :cart_id, :id
    field :quantity, :integer
    belongs_to :product, Product

    timestamps()
  end

  @doc false
  # @impl true
  def changeset(cart_items, attrs) do
    cart_items
    |> cast(attrs, [:quantity])
    |> validate_required([:quantity])
  end


end
