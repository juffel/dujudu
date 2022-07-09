defmodule Dujudu.Factory do
  use ExMachina.Ecto, repo: Dujudu.Repo

  def account_factory do
    %Dujudu.Schemas.Account{
      name: "Chang Doe",
      email: "chang@doe.org",
      password: "passwordpassword123"
    }
  end

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

  def fav_factory do
     %Dujudu.Schemas.Fav{}
  end

  def wikidata_client_request_factory do
    %Dujudu.Wikidata.ClientRequest{
      query: "",
      response_body: "{}"
    }
  end
end
