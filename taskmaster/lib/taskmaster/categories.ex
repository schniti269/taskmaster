defmodule Taskmaster.Categories do
  @moduledoc """
  The Categories context.
  """

  import Ecto.Query, warn: false
  alias Taskmaster.Repo

  alias Taskmaster.Categories.Category

  def list_categories do
    Repo.all(Category)
  end

  def list_categories_with_preloads do
    Repo.all(from c in Category, preload: [:owner, :tasks])
  end

  def list_categories_by_owner(owner_id) do
    Repo.all(from c in Category, where: c.owner_id == ^owner_id, preload: [:owner, :tasks])
  end

  def get_category!(id), do: Repo.get!(Category, id)

  def get_category_with_preloads!(id) do
    Repo.get!(Category, id) |> Repo.preload([:owner, :tasks])
  end

  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end
end
