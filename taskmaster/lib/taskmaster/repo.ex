defmodule Taskmaster.Repo do
  use Ecto.Repo,
    otp_app: :taskmaster,
    adapter: Ecto.Adapters.SQLite3
end
