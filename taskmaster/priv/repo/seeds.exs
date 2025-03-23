# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Taskmaster.Repo.insert!(%Taskmaster.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Taskmaster.Repo
alias Taskmaster.Users.User
alias Taskmaster.Tasks.BigTask
alias Taskmaster.Tasks.Task
alias Taskmaster.Tasks.SharedBigTask
alias Taskmaster.Categories.Category

# Create users
user1 = Repo.insert!(%User{username: "john_doe"})
user2 = Repo.insert!(%User{username: "jane_smith"})

# Create categories
work_category = Repo.insert!(%Category{
  name: "Work",
  color: "#ff0000",
  owner_id: user1.id
})

personal_category = Repo.insert!(%Category{
  name: "Personal",
  color: "#00ff00",
  owner_id: user1.id
})

study_category = Repo.insert!(%Category{
  name: "Study",
  color: "#0000ff",
  owner_id: user2.id
})

# Create big tasks
project_x = Repo.insert!(%BigTask{
  title: "Project X",
  description: "Complete the important project X",
  duedate: DateTime.utc_now() |> DateTime.truncate(:second) |> DateTime.add(14, :day),
  owner_id: user1.id
})

vacation_plan = Repo.insert!(%BigTask{
  title: "Vacation Planning",
  description: "Plan summer vacation",
  duedate: DateTime.utc_now() |> DateTime.truncate(:second) |> DateTime.add(30, :day),
  owner_id: user2.id
})

# Share big tasks
Repo.insert!(%SharedBigTask{
  big_task_id: project_x.id,
  user_id: user2.id
})

# Create tasks
Repo.insert!(%Task{
  title: "Research phase",
  description: "Research market for Project X",
  startdate: DateTime.utc_now() |> DateTime.truncate(:second) |> DateTime.add(1, :day),
  length_in_min: 120,
  is_done: false,
  owner_id: user1.id,
  big_task_id: project_x.id,
  category_id: work_category.id
})

Repo.insert!(%Task{
  title: "Implementation phase",
  description: "Implement Project X features",
  startdate: DateTime.utc_now() |> DateTime.truncate(:second) |> DateTime.add(5, :day),
  length_in_min: 240,
  is_done: false,
  owner_id: user1.id,
  big_task_id: project_x.id,
  category_id: work_category.id
})

Repo.insert!(%Task{
  title: "Book flights",
  description: "Find and book flights for vacation",
  startdate: DateTime.utc_now() |> DateTime.truncate(:second) |> DateTime.add(2, :day),
  length_in_min: 60,
  is_done: false,
  owner_id: user2.id,
  big_task_id: vacation_plan.id,
  category_id: personal_category.id
})

Repo.insert!(%Task{
  title: "Study Elixir",
  description: "Learn Phoenix LiveView",
  startdate: DateTime.utc_now() |> DateTime.truncate(:second),
  length_in_min: 90,
  is_done: true,
  owner_id: user2.id,
  category_id: study_category.id
})
