defmodule InvValidatorWeb.Presence do
  use Phoenix.Presence,
    otp_app: :inv_validator,
    pubsub_server: InvValidatorWeb.PubSub
end
