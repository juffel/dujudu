defmodule Dujudu.Factory do
  use ExMachina.Ecto, repo: Dujudu.Repo

  def ingredient_factory do
    %Dujudu.Schemas.Ingredient{
      title: "bell pepper",
      description: "group of fruits of Capsicum annuum",
      wikidata_id: "Q1548030",
      images: []
    }
  end

  def image_factory do
    %Dujudu.Schemas.Image{
      commons_url: "foo"
    }
  end
end
