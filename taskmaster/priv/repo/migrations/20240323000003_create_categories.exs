defmodule Taskmaster.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string, null: false
      add :color, :string, null: false
      add :owner_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:categories, [:owner_id])
  end
end
