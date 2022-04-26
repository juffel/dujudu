defmodule DujuduWeb.PageController do
  use DujuduWeb, :controller

  alias Dujudu.Access.Images

  def index(conn, _params) do
    image = Images.sample_images(3)
    render(conn, "index.html", sample_images: image)
  end
end
