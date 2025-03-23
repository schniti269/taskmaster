defmodule Taskmaster.Categories.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :name, :string
    field :color, :string

    belongs_to :owner, Taskmaster.Users.User, foreign_key: :owner_id
    has_many :tasks, Taskmaster.Tasks.Task

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:owner_id, :name, :color])
    |> validate_required([:owner_id, :name, :color])
    |> foreign_key_constraint(:owner_id)
  end
end
