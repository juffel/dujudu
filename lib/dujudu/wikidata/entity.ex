defmodule Dujudu.Wikidata.Entity do
  defstruct title: nil,
            description: nil,
            wikidata_id: nil,
            instance_of_wikidata_ids: MapSet.new(),
            subclass_of_wikidata_ids: MapSet.new(),
            commons_image_urls: MapSet.new()
end
