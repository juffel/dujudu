defmodule DujuduWeb.PageController do
  use DujuduWeb, :controller

  alias Dujudu.Access.Ingredients

  def index(conn, _params) do
    ingredient = Ingredients.sample_ingredient()
    render(conn, "index.html", ingredient_of_the_day: ingredient)
  end
end
