defmodule Taskmaster.Tasks.BigTask do
  use Ecto.Schema
  import Ecto.Changeset

  schema "big_tasks" do
    field :title, :string
    field :description, :string
    field :duedate, :utc_datetime

    belongs_to :owner, Taskmaster.Users.User, foreign_key: :owner_id
    has_many :tasks, Taskmaster.Tasks.Task
    has_many :shared_with, Taskmaster.Tasks.SharedBigTask

    timestamps()
  end

  @doc false
  def changeset(big_task, attrs) do
    big_task
    |> cast(attrs, [:title, :description, :duedate, :owner_id])
    |> validate_required([:title, :owner_id])
    |> foreign_key_constraint(:owner_id)
  end
end 