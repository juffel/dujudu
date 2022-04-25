defmodule DujuduWeb.PageController do
  use DujuduWeb, :controller

  alias Dujudu.Access.Images

  def index(conn, _params) do
    image = Images.sample_image()
    render(conn, "index.html", image_of_the_day: image)
  end
end
