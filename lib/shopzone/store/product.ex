defmodule Shopzone.Store.Product do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          title: String.t(),
          description: String.t(),
          stock: integer(),
          amount: integer(),
          thumbnail: String.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "product" do
    field :title, :string
    field :description, :string
    field :stock, :integer
    field :amount, :integer
    field :thumbnail, :string

    timestamps()
  end

  @doc false
  # @impl true
  def changeset(product, attrs)  do
      product
      |> cast(attrs, [:title, :description, :stock, :amount, :thumbnail ])
      |> validate_required([:title, :description, :stock, :amount, :thumbnail])
  end

end
