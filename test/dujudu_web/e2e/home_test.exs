defomdule DujuduWeb.E2E.HomeTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  feature "dummy", %{session: session} do
    session
    |> visit("/")
    |> assert_has("Browse food ingredients")
  end
end
