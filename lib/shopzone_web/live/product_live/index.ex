defmodule ShopzoneWeb.ProductLive.Index do
  alias Shopzone.Store.Product
  alias Shopzone.Store
  use ShopzoneWeb, :live_view


  @impl true
  def mount(session, _params, socket) do
    if connected?(socket), do: Store.subscribe_product_events()

    {:ok,
     socket
     |> assign(:cart_id, session["cart_id"])
     |> stream(:products, Store.list_products())}
  end

  @impl true
  def handle_params(unsigned_params, uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.liva_action, unsigned_params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Product")
    |> assign(:product, Store.get_product!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Add Product")
    |> assign(:product, %Product{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "All Products")
    |> assign(:product, nil)
  end

  @impl true
  def handle_info({ShopzoneWeb.ProductLive.FormComponent, {:saved, product}}, socket) do
    {:noreply, stream_insert(socket, :products, product)}
  end

  @impl true
  def handle_info({:new_product, product}, socket) do
    {:noreply, stream_insert(socket, :products, product)}
  end

  @impl true
  def handle_info({:updated_product, product}, socket) do
    {:noreply, stream_insert(socket, :products, product)}
  end

  @impl true
  def handle_info(:clear_flash, socket) do
    {:noreply, clear_flash(socket)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    product = Store.get_product(id)
    {:ok, _} = Store.delete_product(product)
    {:noreply, stream_delete(socket, :products, product)}
  end

  @impl true
  def handle_event("add_item_to_cart", %{"id" => id}, socket) do
    product = Store.get_product(id)
    Store.add_item_to_cart(socket.assigns.cart_id, product)
    Process.send_after(self(), :clear_flash, 2500)
    {:noreply, socket |> put_flash(:info, "Added Item to Cart")}
  end
end
