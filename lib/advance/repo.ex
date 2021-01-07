defmodule Advance.Repo do
  use Ecto.Repo,
    otp_app: :advance,
    adapter: Ecto.Adapters.Postgres
end
