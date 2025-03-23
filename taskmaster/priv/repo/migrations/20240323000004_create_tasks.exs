defmodule Taskmaster.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string, null: false
      add :description, :text
      add :startdate, :utc_datetime
      add :length_in_min, :integer
      add :is_done, :boolean, default: false, null: false
      add :owner_id, references(:users, on_delete: :delete_all), null: false
      add :big_task_id, references(:big_tasks, on_delete: :nilify_all)
      add :category_id, references(:categories, on_delete: :nilify_all)

      timestamps()
    end

    create index(:tasks, [:owner_id])
    create index(:tasks, [:big_task_id])
    create index(:tasks, [:category_id])
  end
end
