defmodule Dujudu.Access.IngredientsTest do
  use Dujudu.DataCase

  alias Dujudu.Access.Ingredients
  alias Dujudu.Schemas.Ingredient

  describe "list_ingredients/1" do
    test "returns all ingredients" do
      Ingredients.list_ingredients(flop)
    end
  end

  describe "update_ingredients/1" do
    test "inserts new ingredients" do
    end

    test "updates existing ingredients" do
    end

    test "keeps old ingredients" do
    end
  end
end
