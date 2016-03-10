use Mix.Config

if Mix.env == :test do
  config :exvcr, [
    vcr_cassette_library_dir: "test/fixtures/vcr",
  ]
end
