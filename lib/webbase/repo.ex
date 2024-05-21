defmodule Webbase.Repo do
  use Ecto.Repo,
    otp_app: :webbase,
    adapter: Ecto.Adapters.Postgres
end
