defmodule Shopzone.Store do

  import Ecto.Query, warn: false
  alias Shopzone.Store.Order
  alias Shopzone.Store.CartItem
  alias Shopzone.Store.Cart
  alias Shopzone.Store.Product
  alias Shopzone.Repo


  def list_products(), do: Repo.all(Product)

  def get_product(id), do: Repo.get(Product, id)

  def create_product(attrs \\ %{}) do
    result=
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()

    case result  do
      {:ok, new_product} ->
        {:ok, new_product}

      {:error, error} ->
        {:error, error}
    end

  end

  def update_product(%Product{} = product, attrs \\ %{}) do
    result =
      product
      |> Product.changeset(attrs)
      |> Repo.update()

      case result do
        {:ok, upadated_product} ->
          {:ok, upadated_product}

       {:error, error} ->
        {:error, error}
      end
  end


  def change_product(%Product{} = product, attrs \\ %{}) do
      Product.changeset(product, attrs)
  end


  def delete_product(%Product{}= product) do
     Repo.delete(product)
  end


  def broadcast_product_events(event, product) do
     Phoenix.PubSub.broadcast(Shopzone.PubSub, "products", {event, product})
  end

  def subscribe_product_events(event, products) do
    Phoenix.PubSub.subscribe(Shopzone.PubSub, "products")
  end


  def create_cart() do
    Repo.insert(%Cart{status: :open})
  end

  def get_cart(id) do
    Repo.get(Cart, id)
  end

  def list_cart_items(cart_id) do
    CartItem
    |> where([ci], ci.cart_id == ^cart_id)
    |> preload(:product)
    |> Repo.all(CartItem)
  end


  def add_item_to_cart(product, cart_id) do
    Repo.insert(%CartItem{product: product, cart_id: cart_id, quantity: 1},
    conflict_targt: [:qunatity, :cart_id],
    on_conflict: [inc: [quantity: 1]]
    )
  end

  def create_order(cart_id) do
    cart_id
    |> get_cart()
    |> Cart.changeset(%{status: :completed})
    |> Repo.update()

    Repo.insert(%Order{cart_id: cart_id})

  end



end
