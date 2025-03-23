defmodule TaskmasterWeb.SharedBigTaskHTML do
  use TaskmasterWeb, :html

  embed_templates "shared_big_task_html/*"

  @doc """
  Renders a shared big task form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :users, :list, required: true
  attr :big_tasks, :list, required: true

  def shared_big_task_form(assigns)
end
