defmodule Taskmaster.Repo.Migrations.CreateSharedBigTasks do
  use Ecto.Migration

  def change do
    create table(:shared_big_tasks) do
      add :big_task_id, references(:big_tasks, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:shared_big_tasks, [:big_task_id])
    create index(:shared_big_tasks, [:user_id])
    create unique_index(:shared_big_tasks, [:big_task_id, :user_id])
  end
end
