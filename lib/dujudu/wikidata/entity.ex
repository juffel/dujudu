defmodule Dujudu.Wikidata.Entity do
  defstruct title: nil,
            description: nil,
            wikidata_id: nil,
            instance_of_wikidata_ids: [],
            subclass_of_wikidata_ids: [],
            commons_image_urls: []
end
