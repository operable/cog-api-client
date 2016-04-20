defmodule CogApi.Test.FakeHelpers do
  alias CogApi.Endpoint
  alias CogApi.Fake.Client

  def valid_endpoint do
    {:ok, endpoint} = %Endpoint{} |> Client.authenticate
    endpoint
  end

  def create_bundle(params \\ %{}) do
    {:ok, bundle} = Client.bundle_create(valid_endpoint, minimal_bundle_config(params))
    bundle
  end

  def minimal_bundle_config do
    %{name: "bundle",
      version: "0.0.1",
      commands: %{
        test_command: %{
          documentation: "Does a thing",
          rules: ["must have bundle:test_command"]
        }
      }
    }
  end

  def minimal_bundle_config(params) do
    Map.merge(minimal_bundle_config, params)
  end
end
