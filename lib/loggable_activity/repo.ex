defmodule LoggableActivity.Repo do
  use Ecto.Repo,
    otp_app: :loggable_activity,
    adapter: Ecto.Adapters.Postgres
end
