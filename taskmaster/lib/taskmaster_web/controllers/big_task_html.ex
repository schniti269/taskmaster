defmodule TaskmasterWeb.BigTaskHTML do
  use TaskmasterWeb, :html

  embed_templates "big_task_html/*"

  @doc """
  Renders a big_task form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def big_task_form(assigns)
end
