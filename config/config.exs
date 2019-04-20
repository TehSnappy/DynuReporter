use Mix.Config

config :dynu_reporter,
  user_name: "USER_NAME",
  password: "UPDATE_PASSWORD",
  location: "DOMAIN_LOCATION",
  polling_interval: 1000 * 60 * 30

config :dynu_reporter,
  http_adapter: HTTPoison

import_config "#{Mix.env()}.exs"
