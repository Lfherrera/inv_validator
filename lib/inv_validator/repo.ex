defmodule InvValidator.Repo do
  use Ecto.Repo,
    otp_app: :inv_validator,
    adapter: Ecto.Adapters.Postgres
end
