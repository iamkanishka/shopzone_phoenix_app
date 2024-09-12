defmodule ShopzoneWeb.CartLive.Show do
  alias Shopzone.Store
  use ShopzoneWeb, :live_view

  def mount(_params, session, socket) do
    cart_items = Store.list_cart_items(session["cart_id"])

    total =
      cart_items
      |> Enum.map(fn ci -> ci.product.price * ci.qunatity end)
      |> Enum.sum()
      |> Money.new()

    {:ok,
     socket
     |> assign(:total, total)
     |> assign(:cart_id, session["cart_id"])
     |> stream(:cart_items, cart_items)}
  end

  @impl true
  def handle_params(_unsigned_params, _uri, socket) do
   {:noreply, socket}
  end

  @impl true
  def handle_event("checkout", unsigned_params, socket) do
    cart_items = Store.list_cart_items(socket.assigns.cart_id)
    line_items =
      Enum.map(cart_items, fn ci ->
        %{
          price_data: %{
            currency: "usd",
            product_data: %{
              name: ci.product.name,
              description: ci.product.description,
              images: [ci.product.thumbnail]
            },
            unit_amount: ci.product.amount
          },
          quantity: ci.quantity
        }
      end)

    {:ok, checkout_session} =
      Stripe.Checkout.Session.create(%{
        line_items: line_items,
        mode: :payment,
        success_url: url(~p"/cart/success"),
        cancel_url: url(~p"/cart"),
        metadata: %{"cart_id" => socket.assigns.cart_id}
      })

    {:noreply, redirect(socket, external: checkout_session.url)}

  end


end
