defmodule Dujudu.ModelsTest do
  use Dujudu.DataCase

  alias Dujudu.Models

  describe "ingredients" do
    alias Dujudu.Schemas.Ingredient

    import Dujudu.ModelsFixtures

    @invalid_attrs %{name: nil}

    test "list_ingredients/0 returns all ingredients" do
      ingredient = ingredient_fixture()
      assert Models.list_ingredients() == [ingredient]
    end

    test "get_ingredient!/1 returns the ingredient with given id" do
      ingredient = ingredient_fixture()
      assert Models.get_ingredient!(ingredient.id) == ingredient
    end

    test "create_ingredient/1 with valid data creates a ingredient" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Ingredient{} = ingredient} = Models.create_ingredient(valid_attrs)
      assert ingredient.name == "some name"
    end

    test "create_ingredient/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Models.create_ingredient(@invalid_attrs)
    end

    test "update_ingredient/2 with valid data updates the ingredient" do
      ingredient = ingredient_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Ingredient{} = ingredient} = Models.update_ingredient(ingredient, update_attrs)
      assert ingredient.name == "some updated name"
    end

    test "update_ingredient/2 with invalid data returns error changeset" do
      ingredient = ingredient_fixture()
      assert {:error, %Ecto.Changeset{}} = Models.update_ingredient(ingredient, @invalid_attrs)
      assert ingredient == Models.get_ingredient!(ingredient.id)
    end

    test "delete_ingredient/1 deletes the ingredient" do
      ingredient = ingredient_fixture()
      assert {:ok, %Ingredient{}} = Models.delete_ingredient(ingredient)
      assert_raise Ecto.NoResultsError, fn -> Models.get_ingredient!(ingredient.id) end
    end

    test "change_ingredient/1 returns a ingredient changeset" do
      ingredient = ingredient_fixture()
      assert %Ecto.Changeset{} = Models.change_ingredient(ingredient)
    end
  end
end
