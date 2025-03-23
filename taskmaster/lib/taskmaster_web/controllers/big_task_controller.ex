defmodule TaskmasterWeb.BigTaskController do
  use TaskmasterWeb, :controller

  alias Taskmaster.Tasks
  alias Taskmaster.Tasks.BigTask

  def index(conn, _params) do
    big_tasks = Tasks.list_big_tasks()
    render(conn, :index, big_tasks: big_tasks)
  end

  def new(conn, _params) do
    changeset = Tasks.change_big_task(%BigTask{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"big_task" => big_task_params}) do
    case Tasks.create_big_task(big_task_params) do
      {:ok, big_task} ->
        conn
        |> put_flash(:info, "Big task created successfully.")
        |> redirect(to: ~p"/big_tasks/#{big_task}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    big_task = Tasks.get_big_task!(id)
    render(conn, :show, big_task: big_task)
  end

  def edit(conn, %{"id" => id}) do
    big_task = Tasks.get_big_task!(id)
    changeset = Tasks.change_big_task(big_task)
    render(conn, :edit, big_task: big_task, changeset: changeset)
  end

  def update(conn, %{"id" => id, "big_task" => big_task_params}) do
    big_task = Tasks.get_big_task!(id)

    case Tasks.update_big_task(big_task, big_task_params) do
      {:ok, big_task} ->
        conn
        |> put_flash(:info, "Big task updated successfully.")
        |> redirect(to: ~p"/big_tasks/#{big_task}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, big_task: big_task, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    big_task = Tasks.get_big_task!(id)
    {:ok, _big_task} = Tasks.delete_big_task(big_task)

    conn
    |> put_flash(:info, "Big task deleted successfully.")
    |> redirect(to: ~p"/big_tasks")
  end
end
