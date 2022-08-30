defmodule DujuduWeb.E2ECase do
  @moduledoc """
  This module defines the test case to be used by end-to-end
  tests.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.Feature
      import Dujudu.Factory
      import DujuduWeb.E2ECase
    end
  end

  @doc """
  Helper function to wait for a liveview to be fully connected,
  before interacting with it.
  """
  def await_live_connected(session) do
    # use execute_query/2 directly instead of assert_has/2 since assert_has
    # is not a function but a macro, and is harder to properly integrate in
    # a helper function.
    {:ok, _query} = Wallaby.Browser.execute_query(session, Wallaby.Query.css(".phx-connected"))

    session
  end

  @doc """
  Print the current page's html source to the console.
  kudos to https://stackoverflow.com/a/56700661/1870317
  """
  def print_page_source(session) do
    session
    |> Wallaby.Browser.page_source()
    |> IO.inspect()

    # credo:disable-for-previous-line

    session
  end

  @doc """
  Waits for a fixed amount of time. Only use this for debugging,
  not in an actual test, since it causes unnecessary waiting and
  fuzzy results.
  """
  def debug_sleep(session, seconds) do
    Process.sleep(seconds * 1000)

    session
  end
end
