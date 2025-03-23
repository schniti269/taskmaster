defmodule Taskmaster.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string

    has_many :big_tasks, Taskmaster.Tasks.BigTask, foreign_key: :owner_id
    has_many :tasks, Taskmaster.Tasks.Task, foreign_key: :owner_id
    has_many :categories, Taskmaster.Categories.Category, foreign_key: :owner_id
    has_many :shared_big_tasks, Taskmaster.Tasks.SharedBigTask, foreign_key: :user_id

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username])
    |> validate_required([:username])
    |> unique_constraint(:username)
  end
end
