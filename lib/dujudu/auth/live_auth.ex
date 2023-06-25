defmodule DujuduWeb.Auth.LiveAuth do
  require Logger

  import Phoenix.Component

  @claims %{typ: "access"}

  def on_mount(:default, _params, session, socket) do
    token = session["guardian_default_token"]

    with {:ok, claims} <- Dujudu.Auth.Guardian.decode_and_verify(token, @claims),
         {:ok, account} <- Dujudu.Auth.Guardian.resource_from_claims(claims) do
      socket = assign_new(socket, :current_account, fn -> account end)
      {:cont, socket}
    else
      {:error, :invalid_token} ->
        Logger.info("DujuduWeb.Auth.LiveAuth: no account is logged in")
        {:cont, socket}

      {:error, reason} ->
        Logger.info("Auth error in DujuduWeb.Auth.LiveAuth#on_mount/4: #{inspect(reason)}")
        {:cont, socket}
    end
  end
end
