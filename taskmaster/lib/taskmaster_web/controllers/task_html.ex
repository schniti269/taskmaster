defmodule TaskmasterWeb.TaskHTML do
  use TaskmasterWeb, :html

  embed_templates "task_html/*"

  @doc """
  Renders a task form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :categories, :list, required: true
  attr :big_tasks, :list, required: true

  def task_form(assigns)
end
