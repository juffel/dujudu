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
  Print the current page's html source to the console.
  kudos to https://stackoverflow.com/a/56700661/1870317
  """
  def print_page_source(session) do
    session
    |> Wallaby.Browser.page_source()
    |> IO.inspect()

    session
  end
end
