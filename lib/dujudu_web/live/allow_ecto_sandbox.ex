defmodule DujuduWeb.Live.AllowEctoSandbox do
  @moduledoc """
  This module provides necessary additional hooks for liveviews to work properly with Wallaby.
  According to https://github.com/elixir-wallaby/wallaby#liveview
  """
  import Phoenix.LiveView

  def on_mount(:default, _params, _session, socket) do
    allow_ecto_sandbox(socket)
    {:cont, socket}
  end

  defp allow_ecto_sandbox(socket) do
    %{assigns: %{phoenix_ecto_sandbox: metadata}} =
      assign_new(socket, :phoenix_ecto_sandbox, fn ->
        if connected?(socket), do: get_connect_info(socket, :user_agent)
      end)

    Phoenix.Ecto.SQL.Sandbox.allow(metadata, Application.get_env(:dujudu, :sandbox))
  end
end
