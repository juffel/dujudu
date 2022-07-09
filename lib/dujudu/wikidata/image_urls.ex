defmodule Dujudu.Wikidata.ImageUrls do
  @thumbnail_base_url "https://upload.wikimedia.org/wikipedia/commons/thumb"

  @spec resize_wikidata_image(url :: String.t(), height_in_pixels :: Integer.t()) ::
          String.t() | nil
  def resize_wikidata_image(nil, _height), do: nil

  # constructing/guessing a thumbnail url from a wikidata image url feels brittle,
  # but it works^TM - ideally we'd query this via the sparql api, but probably
  # that's not possible; here are short (non-official) instructions on construction
  # of such a thumbnail url: https://stackoverflow.com/a/33691240/1870317
  def resize_wikidata_image(url, height) do
    file_name = extract_file_name(url)
    [hash1, hash2] = file_name_hashes(file_name)
    path_suffix = "#{height}px-#{file_name}"

    [@thumbnail_base_url, hash1, hash2, file_name, path_suffix]
    |> Path.join()
    |> URI.encode()
  end

  defp extract_file_name(url) do
    parsed_url = URI.parse(url)

    parsed_url.path
    |> URI.decode()
    |> String.replace(" ", "_")
    |> String.split("/Special:FilePath/")
    |> List.last()
  end

  defp file_name_hashes(name) do
    hash = :crypto.hash(:md5, name) |> Base.encode16(case: :lower)

    [
      String.first(hash),
      String.slice(hash, 0..1)
    ]
  end
end
