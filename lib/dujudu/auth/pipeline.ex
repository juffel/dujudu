defmodule Dujudu.Auth.Pipeline do
  @claims %{typ: "access"}

  use Guardian.Plug.Pipeline, otp_app: :dujudu,
                              module: Dujudu.Auth.Guardian,
                              error_handler: Dujudu.Auth.ErrorHandler

  plug Guardian.Plug.VerifySession, claims: @claims
  plug Guardian.Plug.VerifyHeader, claims: @claims, realm: "Bearer"
  # plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, allow_blank: true
  plug :set_current_account

  defp set_current_account(conn, _) do
    account = Dujudu.Auth.Guardian.Plug.current_resource(conn)
    assign(conn, :current_account, account)
  end
end