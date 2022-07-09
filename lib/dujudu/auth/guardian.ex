defmodule Dujudu.Auth.Guardian do
  use Guardian, otp_app: :dujudu

  alias Dujudu.Access.Accounts

  def subject_for_token(%{id: id}, _claims) do
    {:ok, to_string(id)}
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(%{"sub" => id}) do
    resource = Accounts.get(id)
    {:ok, resource}
  end

  def resource_from_claims(_) do
    {:error, :reason_for_error}
  end
end
