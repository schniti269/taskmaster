defmodule TaskmasterWeb.SharedBigTaskController do
  use TaskmasterWeb, :controller

  alias Taskmaster.Tasks
  alias Taskmaster.Tasks.SharedBigTask
  alias Taskmaster.Users

  def index(conn, _params) do
    shared_big_tasks = Tasks.list_shared_big_tasks()
    render(conn, :index, shared_big_tasks: shared_big_tasks)
  end

  def new(conn, _params) do
    changeset = Tasks.change_shared_big_task(%SharedBigTask{})

    # Get users and big tasks for the form
    users = Users.list_users()
    big_tasks = Tasks.list_big_tasks()

    render(conn, :new, changeset: changeset, users: users, big_tasks: big_tasks)
  end

  def create(conn, %{"shared_big_task" => shared_big_task_params}) do
    case Tasks.create_shared_big_task(shared_big_task_params) do
      {:ok, shared_big_task} ->
        conn
        |> put_flash(:info, "Task was shared successfully.")
        |> redirect(to: ~p"/shared-big-tasks/#{shared_big_task}")

      {:error, %Ecto.Changeset{} = changeset} ->
        users = Users.list_users()
        big_tasks = Tasks.list_big_tasks()
        render(conn, :new, changeset: changeset, users: users, big_tasks: big_tasks)
    end
  end

  def show(conn, %{"id" => id}) do
    shared_big_task = Tasks.get_shared_big_task!(id)
    render(conn, :show, shared_big_task: shared_big_task)
  end

  def delete(conn, %{"id" => id}) do
    shared_big_task = Tasks.get_shared_big_task!(id)
    {:ok, _shared_big_task} = Tasks.delete_shared_big_task(shared_big_task)

    conn
    |> put_flash(:info, "Shared task removed successfully.")
    |> redirect(to: ~p"/shared-big-tasks")
  end
end
