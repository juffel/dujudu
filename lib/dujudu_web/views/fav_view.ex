defmodule DujuduWeb.FavView do
  use DujuduWeb, :view

  import Flop.Phoenix
  import Dujudu.Wikidata.ImageUrls, only: [resize_wikidata_image: 2]
end
