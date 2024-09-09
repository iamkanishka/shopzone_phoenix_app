defmodule ShopzoneWeb.ProductLive.Show do
  alias Shopzone.Store
  use ShopzoneWeb, :live_view

  @impl true
  @doc false
  def mount(_session,_params, socket) do
    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    {:ok,
     socket
     |> assign(:page_title, page_title(socket.assign.live_action))
     |> assign(:product, Store.get_product(id))}
  end

  defp page_title(:new), do: "Add Product"
  defp page_title(:edit), do: "Edit Product"
end
