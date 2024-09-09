defmodule ShopzoneWeb.ProductLive.FormComponent do
  alias ShopzoneWeb.ProductLive
  use ShopzoneWeb, :live_component

  alias Shopzone.Store

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>
          Product Form Component
        </:subtitle>
      </.header>\
      <.simple_form
        for={@form}
        id="product_form"
        phx-target={@myself}
        phx-update="save"
        phx-change="validate"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:stock]} type="number" label="Stock" />
        <.input field={@form[:price]} type="text" label="Price" />
        <.input field={@form[:thumbnail]} type="text" label="Thumbnail" />
        <:actions>
          <.button phx-disable-with="saving">
            Save Product
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  @doc false
  def update(%{"product" => product} = assigns, socket) do
    changeset = Store.change_product(product)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  @doc false
  def handle_event("validate", %{"product" => product_params}, socket) do
    changeset =
      socket.assigns.product
      |> Store.change_product(product_params)
      |> Map.put(:action, :validate)

      {:noreply, assign_form(changeset, socket)}

  end

  @impl true
  def handle_event("save", %{"product" => product_params}, socket) do
    save_product(socket, socket.assigns.live_action, product_params)
  end

  defp save_product(socket, :edit, product_params) do
        result  = Store.update_product(socket.assigns.product, product_params)
        case result do
          {:ok, updated_product} ->
             notify_parent({:product_updated, updated_product})

             {:noreply,
              socket
              |> put_flash(:info, "Successfully Updated Product")
              |> push_patch(:to, socket.assigns.patch)
            }

          {:error, %Ecto.Changeset{} = changeset} ->
            {:error, assign_form(changeset, socket)}
        end
  end

  defp save_product(socket, :edit, product_params) do
    result  = Store.add_product(socket.assigns.product, product_params)
    case result do
      {:ok, updated_product} ->
         notify_parent({:product_updated, updated_product})

         {:noreply,
          socket
          |> put_flash(:info, "Successfully Updated Product")
          |> push_patch(:to, socket.assigns.patch)
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, assign_form(changeset, socket)}
    end
end


  defp notify_parent(msg) do
     Process.send(self(), {__MODULE__, msg})
  end

  defp assign_form(%Ecto.Changeset{} = changeset, socket) do
    assign(socket, :form, to_form(changeset))
  end
end
