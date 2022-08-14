defmodule DujuduWeb.E2E.BrowseIngredientsTest do
  use DujuduWeb.E2ECase

  setup :insert_demo_ingredients

  feature "browse ingredients and favs", %{session: session} do
    session
    |> login_user()
    |> visit("/")
    |> click(Query.link("Ingredients"))
    |> click(Query.link("cucumber"))
    |> await_live_connected()
    |> click(Query.button("Save fav"))
    |> assert_has(Query.text("💜"))
    |> refute_has(Query.button("Save fav"))
    |> assert_has(Query.button("Unfav"))
    |> click(Query.link("Favourites"))
    |> assert_has(Query.link("cucumber"))
    |> refute_has(Query.text("gochujang"))
    |> click(Query.link("Ingredients"))
    |> click(Query.link("gochujang"))
    |> click(Query.button("Save fav"))
    |> click(Query.link("Favourites"))
    |> assert_has(Query.link("gochujang"))
  end

  defp insert_demo_ingredients(_) do
    limabean =
      insert(:ingredient,
        title: "lima bean",
        wikidata_id: "Q104007010",
        description: "seed from Phaseolus lunatus",
        instance_of_wikidata_id: "Q379813"
      )

    gochujang =
      insert(:ingredient,
        title: "gochujang",
        wikidata_id: "Q699637",
        description: "Korean red chilli paste",
        instance_of_wikidata_id: "Q178359"
      )

    cucumber =
      insert(:ingredient,
        title: "cucumber",
        wikidata_id: "Q2735883",
        description: "fruit used as vegetable",
        instance_of_wikidata_id: "Q25403900"
      )

    %{ingredients: [limabean, gochujang, cucumber]}
  end

  defp login_user(session) do
    account = insert(:account, password: "passwordpassword123")

    session
    |> visit("/")
    |> click(Query.link("Login"))
    |> fill_in(Query.text_field("Email"), with: account.email)
    |> fill_in(Query.text_field("Password"), with: "passwordpassword123")
    |> click(Query.button("Login"))
  end
end
