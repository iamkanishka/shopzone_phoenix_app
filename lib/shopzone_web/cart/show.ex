defmodule ShopzoneWeb.Cart.Show do
  use ShopzoneWeb, :live_view

  alias Shopzone.Store
  alias Shopzone.Store.Product

  def mount(session, params, socket) do
    cart_items = Store.list_cart_items(session["cart_id"])

    total =
      cart_items
      |> Enum.map(fn ci -> ci.product.amount * ci.qunatity end)
      |> Enum.sum()
      |> Money.new()

    {:ok,
     socket
     |> assign(
       :cart_id,
       session["cart_id"]
       |> assign(:total, total)
       |> stream(:cart_items, cart_items)
     )}
  end

   def handle_params(_unsigned_params, _uri, socket) do
     {:noreply, socket}
   end

   def handle_event("checkout", _params, socket) do
     cart_items =  Store.list_cart_items(socket.assigns.cart_id)

     url = ""
      {:noreply, redirect(external: url)}

   end

end
