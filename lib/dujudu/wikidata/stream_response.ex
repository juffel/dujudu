defmodule Dujudu.Wikidata.StreamResponse do
  alias Dujudu.Wikidata.Ingredients
  alias Dujudu.Wikidata.ClientRequest

  @chunk_size 100

  @spec stream_cached_ingredients(ClientRequest.t()) :: Stream.t()
  def stream_cached_ingredients(%ClientRequest{file_path: file_path}) do
    file_path
    |> File.stream!()
    |> Jaxon.Stream.from_enumerable()
    |> Jaxon.Stream.query([:root, "results", "bindings", :all])
    |> Stream.chunk_every(@chunk_size)
    |> Stream.map(fn entities ->
      Ingredients.ingredient_data_from_rows(entities)
    end)
  end
end
