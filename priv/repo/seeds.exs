# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Dujudu.Repo.insert!(%Dujudu.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Dujudu.Repo.insert!(%Dujudu.Models.Ingredient{
  title: "paprika",
  unit: :kilo,
  wikidata_id: "Q3127593",
}, conflict_target: :wikidata_id, on_conflict: :replace_all)

Dujudu.Repo.insert!(%Dujudu.Models.Ingredient{
  title: "cinnamon",
  unit: :kilo,
  wikidata_id: "Q28165",
}, conflict_target: :wikidata_id, on_conflict: :replace_all)

Dujudu.Repo.insert!(%Dujudu.Models.Ingredient{
  title: "hemp milk",
  unit: :liter,
  wikidata_id: "Q13099103",
}, conflict_target: :wikidata_id, on_conflict: :replace_all)
