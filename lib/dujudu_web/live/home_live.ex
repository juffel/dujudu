defmodule DujuduWeb.HomeLive do
  use DujuduWeb, :live_view

  alias Dujudu.Access.Images

  import Dujudu.Wikidata.ImageUrls, only: [resize_wikidata_image: 2]

  on_mount DujuduWeb.Auth.LiveAuth

  def mount(_params, _session, socket) do
    sample_images = Images.sample_images(9)

    {:ok, assign(socket, sample_images: sample_images)}
  end
end
