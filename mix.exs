defmodule CogApi.Mixfile do
  use Mix.Project

  def project do
    [
      app: :cog_api,
      version: "0.13.0",
      elixir: "~> 1.2",
      elixirc_paths: elixirc_paths(Mix.env),
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps,
      dialyzer: dialyzer_settings,
    ]
  end

  defp dialyzer_settings do
    [
      plt_add_deps: true,
      plt_file: ".dialyzer.plt",
      flags: ["-Wunderspecs", "-Wno_undefined_callbacks"]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  def application do
    [
      applications: [:logger, :httpotion],
    ]
  end

  defp deps do
    [
      {:ex_spec, "~> 1.0.0", only: :test},
      {:exvcr, github: "operable/exvcr", branch: "fix-cached-status-code", only: [:dev, :test]},
      {:httpotion, "~> 2.1.0"},
      {:ibrowse, "~> 4.2.2", override: true},
      {:poison, "~> 2.0"},
      {:dialyxir, "~> 0.3"},

      {:mix_test_watch, "~> 0.1.1", only: [:test, :dev]}
    ]
  end
end
