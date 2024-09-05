defmodule Plotlab.Repo do
  use Ecto.Repo,
    otp_app: :plotlab,
    adapter: Ecto.Adapters.Postgres
end
