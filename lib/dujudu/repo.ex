defmodule Dujudu.Repo do
  use Ecto.Repo,
    otp_app: :dujudu,
    adapter: Ecto.Adapters.Postgres
end
