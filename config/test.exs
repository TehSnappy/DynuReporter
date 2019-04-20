use Mix.Config

config :dynu_reporter,
  http_adapter: MyHttpPoison,
  polling_interval: 1000

config :logger, level: :warn
