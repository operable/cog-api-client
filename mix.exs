defmodule CogApi.Mixfile do
  use Mix.Project

  def project do
    [
      app: :cog_api,
      version: "1.1.0",
      elixir: "~> 1.3.1",
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
      {:dialyxir, "~> 0.3", only: [:dev, :test]},
      {:ex_spec, "~> 2.0.0", only: :test},
      {:exvcr, "~> 0.8", only: [:dev, :test]},
      {:httpotion, "~> 3.0"},
      {:mix_test_watch, "~> 0.2", only: [:test, :dev]},
      {:poison, "~> 2.0"}
    ]
  end
end
