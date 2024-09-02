defmodule Shopzone.Store.Cart do
  use Ecto.Schema
  import Ecto.Changeset

  schema "carts" do
    field :status, Ecto.Enum, values: [:open, :onhold, :completed]
    timestamps()
  end

  @doc false
  # @impl true
  def changeset(cart, attrs) do
    cart
    |> cast(cart, [])
    |> validate_required([])
  end
end
