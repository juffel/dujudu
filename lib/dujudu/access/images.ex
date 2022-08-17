defmodule Dujudu.Access.Images do
  alias Dujudu.Schemas.Image
  alias Dujudu.Repo

  import Ecto.Query, only: [from: 2]

  def sample_images(length, seed) do
    query =
      from i in Image,
        order_by: fragment("md5(id || ?)", ^seed),
        limit: ^length,
        preload: :ingredient

    Repo.all(query)
  end
end
