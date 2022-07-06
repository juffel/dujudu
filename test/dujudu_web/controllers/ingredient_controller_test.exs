defmodule DujuduWeb.IngredientControllerTest do
  use DujuduWeb.ConnCase

  describe "index" do
    test "lists all ingredients", %{conn: conn} do
      conn = get(conn, Routes.ingredient_path(conn, :index))
      assert html_response(conn, 200) =~ "Ingredients"
    end
  end
end
