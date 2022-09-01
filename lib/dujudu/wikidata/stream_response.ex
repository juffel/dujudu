defmodule Dujudu.Wikidata.StreamResponse do
  require Logger

  alias Dujudu.Wikidata.{Client, ClientRequest, Ingredients}
  alias Dujudu.Wikidata.Access.ClientRequests

  @chunk_size 100

  @spec stream_cached_ingredients() :: Stream.t() | {:error, any()}
  def stream_cached_ingredients() do
    case get_cached_client_request() do
      {:ok, client_request} ->
        client_request
        |> stream_response()
        |> Stream.chunk_every(@chunk_size)
        |> Stream.map(fn entities ->
          Ingredients.ingredient_data_from_rows(entities)
        end)

      {:error, reason} -> {:error, reason}
    end
  end

  @spec get_cached_client_request() :: {:ok, ClientRequest.t()} | {:error, any()}
  def get_cached_client_request() do
    case ClientRequests.get_cached() do
      nil -> fetch_new_request()
      client_request -> {:ok, client_request}
    end
  end

  defp stream_response(%ClientRequest{file_path: file_path}) do
    file_path
    |> File.stream!()
    |> Jaxon.Stream.from_enumerable()
    |> Jaxon.Stream.query([:root, "results", "bindings", :all])
  end

  @spec fetch_new_request(boolean()) :: {:ok, ClientRequest.t()} | {:error, any()}
  defp fetch_new_request(retry \\ true) do
    case Client.get_request() do
      {:ok, request} ->
        {:ok, request}

      {:error, :wikidata_client_timeout} ->
        Logger.info("wikidata client timeout")
        if retry do
          Logger.info("retrying...")
          fetch_new_request(false)
        else
          {:error, :timeout}
        end

      {:error, reason} -> {:error, reason}
    end
  end
end
