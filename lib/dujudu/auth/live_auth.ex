defmodule DujuduWeb.Auth.LiveAuth do
  import Phoenix.LiveView

  @claims %{typ: "access"}

  def on_mount(:default, _params, session, socket) do
    token = session["guardian_default_token"]

    with {:ok, claims} <- Dujudu.Auth.Guardian.decode_and_verify(token, @claims),
         {:ok, account} <- Dujudu.Auth.Guardian.resource_from_claims(claims) do
      socket = assign_new(socket, :current_account, fn -> account end)
      {:cont, socket}
    else
      {:error, reason} ->
        IO.inspect(reason, label: "Auth error in Auth.LiveAuth#on_mount/4")
        {:cont, socket}
    end
  end
end
