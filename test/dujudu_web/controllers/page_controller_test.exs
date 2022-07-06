defmodule DujuduWeb.PageControllerTest do
  use DujuduWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Browse food ingredients"
  end
end
