defmodule DujuduWeb.PageController do
  use DujuduWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
