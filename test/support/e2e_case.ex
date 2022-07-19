defmodule DujuduWeb.E2ECase do
  @moduledoc """
  This module defines the test case to be used by end-to-end
  tests.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.Feature
      import DujuduWeb.E2ECase
    end
  end
end
