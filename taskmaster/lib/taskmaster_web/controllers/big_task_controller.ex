defmodule TaskmasterWeb.BigTaskController do
  use TaskmasterWeb, :controller

  alias Taskmaster.Tasks
  alias Taskmaster.Tasks.BigTask

  def index(conn, _params) do
    big_tasks = Tasks.list_big_tasks_with_preloads()
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
        |> redirect(to: ~p"/big-tasks/#{big_task}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    big_task = Tasks.get_big_task_with_preloads!(id)

    # Calculate task statistics
    tasks = big_task.tasks
    done_tasks = Enum.filter(tasks, & &1.is_done)
    todo_tasks = Enum.filter(tasks, & !&1.is_done)

    # Calculate minutes per day stats
    total_minutes = Enum.reduce(tasks, 0, fn task, acc -> acc + (task.length_in_min || 0) end)
    done_minutes = Enum.reduce(done_tasks, 0, fn task, acc -> acc + (task.length_in_min || 0) end)
    todo_minutes = total_minutes - done_minutes

    # Calculate completion percentage
    completed_percent = if total_minutes > 0, do: round((done_minutes / total_minutes) * 100), else: 0

    # Calculate minutes per day
    today = DateTime.utc_now()
    due_date = big_task.duedate
    days_difference = max(1, ceil(DateTime.diff(due_date, today, :second) / (60 * 60 * 24)))
    minutes_per_day = round(todo_minutes / days_difference)

    render(conn, :show, big_task: big_task,
                        minutes_per_day: minutes_per_day,
                        completed_percent: completed_percent)
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
        |> redirect(to: ~p"/big-tasks/#{big_task}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, big_task: big_task, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    big_task = Tasks.get_big_task!(id)
    {:ok, _big_task} = Tasks.delete_big_task(big_task)

    conn
    |> put_flash(:info, "Big task deleted successfully.")
    |> redirect(to: ~p"/big-tasks")
  end
end
