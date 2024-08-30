defmodule Shopzone.Store.Order do

  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :cart_id, :id
    timestamps()
  end

  @doc false
  # @impl true
  def chnageset(order, attrs) do
    order
    |> cast(attrs, [:cart_id])
    |> validate_required([:cart_id])
  end

end
