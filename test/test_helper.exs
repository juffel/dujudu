ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Dujudu.Repo, :manual)

{:ok, _} = Application.ensure_all_started(:wallaby)
Application.put_env(:wallaby, :base_url, DujuduWeb.Endpoint.url()) # Guess I'll have to use the docker-chrome-network URI here
