defmodule Taskmaster.Repo.Migrations.CreateBigTasks do
  use Ecto.Migration

  def change do
    create table(:big_tasks) do
      add :title, :string, null: false
      add :description, :text
      add :duedate, :utc_datetime
      add :owner_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:big_tasks, [:owner_id])
  end
end
