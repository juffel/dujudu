defmodule DujuduWeb.PageView do
  use DujuduWeb, :view

  import Dujudu.Wikidata.ImageUrls, only: [resize_wikidata_image: 2]
end
