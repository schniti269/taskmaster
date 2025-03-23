defmodule TaskmasterWeb.TaskController do
  use TaskmasterWeb, :controller

  alias Taskmaster.Tasks
  alias Taskmaster.Tasks.Task
  alias Taskmaster.Categories

  def index(conn, params) do
    tasks = case params["status"] do
      "done" ->
        Tasks.list_tasks_with_preloads()
        |> Enum.filter(& &1.is_done)
      "todo" ->
        Tasks.list_tasks_with_preloads()
        |> Enum.filter(& !&1.is_done)
      _ ->
        Tasks.list_tasks_with_preloads()
    end

    render(conn, :index, tasks: tasks)
  end

  def new(conn, _params) do
    changeset = Tasks.change_task(%Task{})
    categories = Categories.list_categories()
    big_tasks = Tasks.list_big_tasks()
    render(conn, :new, changeset: changeset, categories: categories, big_tasks: big_tasks)
  end

  def create(conn, %{"task" => task_params}) do
    case Tasks.create_task(task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: ~p"/tasks/#{task}")

      {:error, %Ecto.Changeset{} = changeset} ->
        categories = Categories.list_categories()
        big_tasks = Tasks.list_big_tasks()
        render(conn, :new, changeset: changeset, categories: categories, big_tasks: big_tasks)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Tasks.get_task_with_preloads!(id)
    render(conn, :show, task: task)
  end

  def edit(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    changeset = Tasks.change_task(task)
    categories = Categories.list_categories()
    big_tasks = Tasks.list_big_tasks()
    render(conn, :edit, task: task, changeset: changeset, categories: categories, big_tasks: big_tasks)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Tasks.get_task!(id)

    case Tasks.update_task(task, task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: ~p"/tasks/#{task}")

      {:error, %Ecto.Changeset{} = changeset} ->
        categories = Categories.list_categories()
        big_tasks = Tasks.list_big_tasks()
        render(conn, :edit, task: task, changeset: changeset, categories: categories, big_tasks: big_tasks)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    {:ok, _task} = Tasks.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: ~p"/tasks")
  end

  def complete(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)

    # Toggle the is_done status
    update_attrs = %{is_done: !task.is_done}

    case Tasks.update_task(task, update_attrs) do
      {:ok, task} ->
        status = if task.is_done, do: "completed", else: "reopened"

        conn
        |> put_flash(:info, "Task #{status} successfully.")
        |> redirect(to: ~p"/tasks/#{task}")

      {:error, %Ecto.Changeset{} = _changeset} ->
        conn
        |> put_flash(:error, "Could not update task status.")
        |> redirect(to: ~p"/tasks/#{task}")
    end
  end
end
