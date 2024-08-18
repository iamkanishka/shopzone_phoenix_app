defmodule Shopzone.Repo do
  use Ecto.Repo,
    otp_app: :shopzone,
    adapter: Ecto.Adapters.Postgres
end
