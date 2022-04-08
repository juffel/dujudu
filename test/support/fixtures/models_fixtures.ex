defmodule Dujudu.ModelsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Dujudu.Models` context.
  """

  @doc """
  Generate a ingredient.
  """
  def ingredient_fixture(attrs \\ %{}) do
    {:ok, ingredient} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Dujudu.Models.create_ingredient()

    ingredient
  end
end
