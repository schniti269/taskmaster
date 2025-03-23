defmodule Taskmaster.Tasks do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false
  alias Taskmaster.Repo

  alias Taskmaster.Tasks.BigTask
  alias Taskmaster.Tasks.Task
  alias Taskmaster.Tasks.SharedBigTask

  # BigTask functions

  def list_big_tasks do
    Repo.all(BigTask)
  end

  def list_big_tasks_with_preloads do
    Repo.all(from bt in BigTask, preload: [:owner, :shared_with, tasks: [:category]])
  end

  def get_big_task!(id), do: Repo.get!(BigTask, id)

  def get_big_task_with_preloads!(id) do
    Repo.get!(BigTask, id) |> Repo.preload([:owner, :shared_with, tasks: [:category]])
  end

  def create_big_task(attrs \\ %{}) do
    %BigTask{}
    |> BigTask.changeset(attrs)
    |> Repo.insert()
  end

  def update_big_task(%BigTask{} = big_task, attrs) do
    big_task
    |> BigTask.changeset(attrs)
    |> Repo.update()
  end

  def delete_big_task(%BigTask{} = big_task) do
    Repo.delete(big_task)
  end

  def change_big_task(%BigTask{} = big_task, attrs \\ %{}) do
    BigTask.changeset(big_task, attrs)
  end

  # Task functions

  def list_tasks do
    Repo.all(Task)
  end

  def list_tasks_with_preloads do
    Repo.all(from t in Task, preload: [:owner, :big_task, :category])
  end

  def list_tasks_by_category(category_id) do
    Repo.all(from t in Task, where: t.category_id == ^category_id, preload: [:owner, :big_task, :category])
  end

  def list_tasks_by_big_task(big_task_id) do
    Repo.all(from t in Task, where: t.big_task_id == ^big_task_id, preload: [:owner, :big_task, :category])
  end

  def list_completed_tasks do
    Repo.all(from t in Task, where: t.is_done == true, preload: [:owner, :big_task, :category])
  end

  def list_incomplete_tasks do
    Repo.all(from t in Task, where: t.is_done == false, preload: [:owner, :big_task, :category])
  end

  def get_task!(id), do: Repo.get!(Task, id)

  def get_task_with_preloads!(id) do
    Repo.get!(Task, id) |> Repo.preload([:owner, :big_task, :category])
  end

  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end

  # SharedBigTask functions

  def list_shared_big_tasks do
    Repo.all(SharedBigTask) |> Repo.preload([:big_task, :user])
  end

  def list_shared_big_tasks_by_user(user_id) do
    Repo.all(from s in SharedBigTask, where: s.user_id == ^user_id, preload: [:big_task, :user])
  end

  def get_shared_big_task!(id), do: Repo.get!(SharedBigTask, id) |> Repo.preload([:big_task, :user])

  def create_shared_big_task(attrs \\ %{}) do
    %SharedBigTask{}
    |> SharedBigTask.changeset(attrs)
    |> Repo.insert()
  end

  def delete_shared_big_task(%SharedBigTask{} = shared_big_task) do
    Repo.delete(shared_big_task)
  end

  def change_shared_big_task(%SharedBigTask{} = shared_big_task, attrs \\ %{}) do
    SharedBigTask.changeset(shared_big_task, attrs)
  end
end
