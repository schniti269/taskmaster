defmodule Taskmaster.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :title, :string
    field :description, :string
    field :startdate, :utc_datetime
    field :length_in_min, :integer
    field :is_done, :boolean, default: false

    belongs_to :owner, Taskmaster.Users.User, foreign_key: :owner_id
    belongs_to :big_task, Taskmaster.Tasks.BigTask, foreign_key: :big_task_id
    belongs_to :category, Taskmaster.Categories.Category, foreign_key: :category_id

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :description, :owner_id, :big_task_id, :startdate, :length_in_min, :is_done, :category_id])
    |> validate_required([:title, :owner_id])
    |> foreign_key_constraint(:owner_id)
    |> foreign_key_constraint(:big_task_id)
    |> foreign_key_constraint(:category_id)
  end
end
