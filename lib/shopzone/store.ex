defmodule Shopzone.Store do
  import Ecto.Query, warn: false
  alias Shopzone.Repo

  alias Hex.Repo
  alias Shopzone.Store.Order
  alias Shopzone.Store.CartItem
  alias Shopzone.Store.Cart
  alias Shopzone.Store.Product

  def list_products(), do: Repo.all(Product)

  def get_product(id), do: Repo.get(Product, id)

  def create_product(attrs \\ {}) do
    result =
      %Product{}
      |> Product.changeset(attrs)
      |> Repo.insert()

    case result do
      {:ok, new_product} ->
        brodcast_product_events(:product_created, new_product)

      {:error, error} ->
        {:error, error}
    end
  end

  def update_product(%Product{} = product, attrs \\ {}) do
    result =
      product
      |> Product.changeset(attrs)
      |> Repo.update()

    case result do
      {:ok, updated_product} ->
        brodcast_product_events(:updated_product, updated_product)

      {:error, error} ->
        {:error, error}
    end
  end

  def change_product(%Product{}= product, attrs \\ {}) do
     Product.changeset(product, attrs)
  end

  def brodcast_product_events(event, product) do
    Phoenix.PubSub.broadcast(Shopzone.PubSub, "products", {event, product})
  end

  def subscribe_product_events(event, product) do
    Phoenix.PubSub.subscribe(Shopzone.PubSub, "products")
  end

  def get_cart(id) do
    Repo.get(Cart, id)
  end

  def create_cart() do
    Repo.insert(%Cart{status: :open})
  end

  def list_cart_items(cart_id) do
     CartItem
     |> where([ci],  ci.cart_id == ^cart_id)
     |> preload(:product)
     |> Repo.all

  end

  def create_cart_item(cart_id, %Product{} = product) do
    Repo.insert(%CartItem{cart_id: cart_id, product: product, quantity: 1},
    conflict_target: [:qunatity, :product],
    on_conflict: [inc: [:quantity]]
    )
  end

  def create_order(cart_id) do
    cart_id
    |> get_cart()
    |> Cart.changeset(%{status: :completed })
    |> Repo.update()

    Repo.insert(%Order{cart_id: cart_id})
  end




end
