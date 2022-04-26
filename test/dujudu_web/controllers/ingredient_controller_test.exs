defmodule DujuduWeb.IngredientControllerTest do
  use DujuduWeb.ConnCase

  @invalid_attrs %{name: nil}

  describe "index" do
    test "lists all ingredients", %{conn: conn} do
      conn = get(conn, Routes.ingredient_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Ingredients"
    end
  end
end
