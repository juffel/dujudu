defmodule DujuduWeb.E2E.HomeTest do
  use DujuduWeb.E2ECase

  feature "dummy", %{session: session} do
    session
    |> visit("/")
    |> assert_has(Query.text("Browse food ingredients"))
    |> assert_has(Query.text("Frowse food ingredients"))
  end
end
