defmodule Dujudu.Factory do
  use ExMachina.Ecto, repo: Dujudu.Repo

  def account_factory(attrs) do
    password = Map.get(attrs, :password, "passwordpassword123")

    %Dujudu.Schemas.Account{
      name: "Chang Doe",
      email: "chang@doe.org"
    }
    # explicitly populate password_hash field
    |> Map.merge(Argon2.add_hash(password))
    |> merge_attributes(attrs)
    |> evaluate_lazy_attributes()
  end

  def ingredient_factory do
    %Dujudu.Schemas.Ingredient{
      title: "bell pepper",
      description: "group of fruits of Capsicum annuum",
      wikidata_id: sequence(:wikidata_id, &"Q1234#{&1}")
    }
  end

  def fav_factory do
    %Dujudu.Schemas.Fav{}
  end

  def wikidata_client_request_factory do
    %Dujudu.Wikidata.ClientRequest{
      query: "SELECT SOMETHING",
      file_path: "tmp/some/path"
    }
  end
end
