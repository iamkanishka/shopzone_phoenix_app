defmodule ShopzoneWeb.ProductLive.Show do
  use ShopzoneWeb, :live_view
  alias Shopzone.Store

  @impl true
  def mount(_session, _prams, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _uri, socket) do
    {:noreply,
     socket
     |> assign(:page_title, get_title(socket.assigns.live_action))
     |> assign(:product, Store.get_product(id))}
  end

  defp get_title(:edit), do: "Edit Product"
  defp get_title(:new), do: "Add Product"
end
