defmodule DynuReporter.MixProject do
  use Mix.Project

  def project do
    [
      app: :dynu_reporter,
      version: "1.0.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      package: package(),
      description: description(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {DynuReporter.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.4"},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "DynuReporter is a client for the Dynu Dynamic DNS service (dynu.com). Use it to assign domain names to servers with dynamic IP addresses."
  end

  defp package() do
    [
      files: ~w(lib .formatter.exs mix.exs README* LICENSE*),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/TehSnappy/DynuReporter"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
