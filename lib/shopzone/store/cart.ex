defmodule Shopzone.Store.Cart do
  use Ecto.Schema
  import Ecto.Changeset

  schema "carts" do
    field :status, Ecto.Enum, values: [:open, :completed, :onhold]
   timestamps()
  end

  @impl true
  @doc false
  def changeset(cart, attrs) do
    cart
    |> cast(attrs, [:status])
    |> validate_required([:status])
  end
end
