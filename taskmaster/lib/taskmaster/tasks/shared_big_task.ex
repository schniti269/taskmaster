defmodule Taskmaster.Tasks.SharedBigTask do
  use Ecto.Schema
  import Ecto.Changeset

  schema "shared_big_tasks" do
    belongs_to :big_task, Taskmaster.Tasks.BigTask, foreign_key: :big_task_id
    belongs_to :user, Taskmaster.Users.User, foreign_key: :user_id

    timestamps()
  end

  @doc false
  def changeset(shared_big_task, attrs) do
    shared_big_task
    |> cast(attrs, [:big_task_id, :user_id])
    |> validate_required([:big_task_id, :user_id])
    |> foreign_key_constraint(:big_task_id)
    |> foreign_key_constraint(:user_id)
    |> unique_constraint([:big_task_id, :user_id])
  end
end
