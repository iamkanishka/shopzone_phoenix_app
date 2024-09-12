defmodule ShopzoneWeb.ProductLive.FormComponent do

  alias Shopzone.Store
  use ShopzoneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Product Form Component</:subtitle>
      </.header>

      <.simple_form
        id="product_form"
        for={@form}
        phx-update="validate"
        phx-submit="save"
        phx-target={@myself}
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:stock]} type="text" label="Stock" />
        <.input field={@form[:qunatity]} type="text" label="Qunatity" />
        <.input field={@form[:thumnail]} type="text" label="Thumnail" />
        <:actions>
          <.button phx-disable-with="saving">Save</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def update(%{product: product} = assigns, socket) do
    changeset = Store.change_product(product)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"product" => product_params}, socket) do
    changeset =
      socket.assigns.product
      |> Store.change_product(product_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  @impl true
  def handle_event("save", %{"product" => product_params}, socket) do
    save_product(socket, socket.assigns.action, product_params)
  end

  defp save_product(socket, :edit, product_params) do
    result = Store.update_product(socket.assigns.product, product_params)

    case result do
      {:ok, updated_product} ->
        notify_parent({:saved, updated_product})

        {:noreply,
         socket
         |> put_flash(:info, "ProductUpdated succesfully")
         |> push_patch(to: socket.assigns.patch)}
      {:error, %Ecto.Changeset{} = changeset} ->
         {:error, assign_form(socket, changeset)}
    end
  end


  defp save_product(socket, :new, product_prams) do
    result = Store.create_product(product_prams)
    case result do
      {:ok, new_product} ->
         notify_parent({:saved, new_product})
         {:noreply,
           socket
           |> put_flash(:info, "Product Added Successfully")
           |> push_patch(to: socket.assigns.patch)
        }
      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg) do
     Process.send(self(), {__MODULE__, msg})
  end

end
