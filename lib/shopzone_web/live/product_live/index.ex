defmodule ShopzoneWeb.ProductLive.Index do
  alias Shopzone.Store.Product
  alias Shopzone.Store
  use ShopzoneWeb, :live_view

  @impl true
  def mount(session, params, socket) do
    {:ok,
     socket
     |> assign(:cart_id, session[~c"cart_id"])
     |> assign(:products, Store.list_products())}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Ptroduct")
    |> assign(:product, Store.get_product(id))
  end

  defp apply_action(socket, :new, _parmas) do
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
  @doc false
  def handle_info({ShopzoneWeb.ProductLive.FormComponent, {:saved, product}}, socket) do
    {:noreply, stream_insert(socket, :products, product)}
  end

  @impl true
  @doc false
  def handle_info({:updated_product, product}, socket) do
    {:noreply, stream_insert(socket, :products, product)}
  end


  @impl true
  @doc false
  def handle_info({:created_product, product}, socket) do
    {:noreply, stream_insert(socket, :products, product)}
  end

  @impl true
  @doc false
 def handle_info(:clear_flash, socket) do
    {:noreply, clear_flash(socket)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    product = Store.get_product!(id)

    {:ok, _} = Store.delete_product(product)
    {:noreply, stream_delete(socket, :products, product)}
  end

  def handle_event("add_to_cart", %{"id" => id}, socket) do
    product = Store.get_product!(id)

    Store.create_cart_item(socket.assigns.cart_id, product)

    Process.send_after(self(), :clear_flash, 2500)
  {:noreply, socket |> put_flash(:info, "Added to Cart Successfully")}
  end
end
