defmodule DujuduWeb.HomeLive do
  use DujuduWeb, :live_view

  alias Dujudu.Access.Images

  import Dujudu.Wikidata.ImageUrls, only: [resize_wikidata_image: 2]

  @seed_chars '-_'

  on_mount DujuduWeb.Auth.LiveAuth

  def mount(%{"seed" => seed}, _session, socket) do
    sample_images = Images.sample_images(9, sanitize_seed(seed))

    {:ok, assign(socket, sample_images: sample_images)}
  end

  def mount(_params, _session, socket) do
    {:ok, push_redirect(socket, to: Routes.live_path(socket, __MODULE__, seed: generate_seed()))}
  end

  defp generate_seed() do
    for _ <- 1..16, into: "", do: <<Enum.random(@seed_chars)>>
  end

  defp sanitize_seed(seed) do
    :crypto.hash(:md5, seed) |> Base.encode16()
  end
end
