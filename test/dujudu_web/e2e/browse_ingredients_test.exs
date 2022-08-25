defmodule DujuduWeb.E2E.BrowseIngredientsTest do
  use DujuduWeb.E2ECase

  setup :insert_demo_ingredients

  feature "browse ingredients and favs", %{session: session} do
    session
    |> login_user()
    |> visit("/")
    |> click(Query.link("Ingredients"))
    |> await_live_connected()
    |> click(Query.link("cucumber"))
    |> click(Query.button("Save fav"))
    |> assert_has(Query.text("💜"))
    |> refute_has(Query.button("Save fav"))
    |> assert_has(Query.button("Unfav"))
    |> click(Query.link("Favourites"))
    |> assert_has(Query.link("cucumber"))
    |> refute_has(Query.text("gochujang"))
    |> click(Query.link("Ingredients"))
    |> await_live_connected()
    |> click(Query.link("gochujang"))
    |> click(Query.button("Save fav"))
    |> click(Query.link("Favourites"))
    |> assert_has(Query.link("gochujang"))
  end

  feature "browse similar ingredients", %{session: session, ingredients: [limabean, _gochujang, cucumber]} do
    insert_similar_ingredients()

    session
    |> login_user()
    |> visit("/ingredients/" <> limabean.id)
    |> await_live_connected()
    |> refute_has(Query.link("flour"))
    |> click(Query.link("mung bean"))
    |> assert_has(Query.text("bean from Vigna radiata"))
    |> visit("/ingredients/" <> cucumber.id)
    |> await_live_connected()
    |> refute_has(Query.link("mung bean"))
    |> click(Query.link("flour"))
    |> assert_has(Query.text("powder which is made by grinding cereal grains"))
  end

  feature "search ingredients", %{session: session} do
    session
    |> login_user()
    |> visit("/")
    |> click(Query.link("Ingredients"))
    |> await_live_connected()
    |> assert_has_link("lima bean")
    |> assert_has_link("gochujang")
    |> assert_has_link("cucumber")
    |> fill_in(Query.text_field("Search"), with: "be")
    |> refute_has_link("gochuchang")
    |> assert_has_link("lima bean")
    |> assert_has_link("cucumber")
    |> fill_in(Query.text_field("Search"), with: "bean")
    |> refute_has_link("cucumber")
    |> refute_has_link("gochujang")
    |> assert_has_link("lima bean")
    |> fill_in(Query.text_field("Search"), with: "beanie")
    |> refute_has_link("lima bean")
    |> refute_has_link("cucumber")
    |> refute_has_link("gochujang")
    |> fill_in(Query.text_field("Search"), with: "Q2735883")
    |> assert_has_link("cucumber")
    |> refute_has_link("lima bean")
    |> refute_has_link("gochujang")
    |> clear_search_input()
    |> assert_has_link("lima bean")
    |> assert_has_link("gochujang")
    |> assert_has_link("cucumber")
  end

  @doc """
  Helper to fully clearthe search input field. Simply filling it
  with an empty string does not trigger an action within chromedriver.
  """
  def clear_search_input(session) do
    session
    |> fill_in(Query.text_field("Search"), with: " ")
    |> click(Query.text_field("Search"))
    |> send_keys([:backspace])

    session
  end

  defp assert_has_link(session, label) do
    assert_has(session, Query.link(label))
  end

  @doc """
  This helper function emulates a refute_has assertion, which
  waits for the element to disappear. This is necessary since
  refute_has does not have blocking behaviour, like assert_has.
  """
  def refute_has_link(session, label) do
    find(session, Query.link(label, count: 0))

    session
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

  defp insert_similar_ingredients() do
    mungbean =
      insert(:ingredient,
        title: "mung bean",
        wikidata_id: "Q104664662",
        instance_of_wikidata_id: "Q379813",
        description: "bean from Vigna radiata"
      )

    flour =
      insert(:ingredient,
        title: "flour",
        wikidata_id: "Q36465",
        instance_of_wikidata_id: "Q25403900",
        description: "powder which is made by grinding cereal grains"
      )

    %{similar_ingredients: [mungbean, flour]}
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
