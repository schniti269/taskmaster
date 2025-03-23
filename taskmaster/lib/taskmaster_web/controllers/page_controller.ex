defmodule TaskmasterWeb.PageController do
  use TaskmasterWeb, :controller

  alias Taskmaster.Tasks
  alias Taskmaster.Categories

  def home(conn, _params) do
    # Get data for the dashboard
    tasks = Tasks.list_tasks() |> Taskmaster.Repo.preload([:category, :big_task])
    categories = Categories.list_categories()

    # Count statistics
    stats = %{
      total_tasks: length(tasks),
      completed_tasks: Enum.count(tasks, & &1.is_done),
      big_tasks: length(Tasks.list_big_tasks()),
      categories: length(categories)
    }

    render(conn, :home, page_title: "Dashboard", tasks: tasks, categories: categories, stats: stats)
  end
end
