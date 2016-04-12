defmodule CogApi.Test.FakeHelpers do
  alias CogApi.Endpoint
  alias CogApi.Fake.Client

  def fake_endpoint do
    {:ok, endpoint} = %Endpoint{} |> CogApi.Fake.Client.authenticate
    endpoint
  end

  def create_bundle(params \\ %{}) do
    {:ok, bundle} = Client.bundle_create(fake_endpoint, minimal_bundle_config(params))
    bundle
  end

  defp minimal_bundle_config(params) do
    defaults = %{
      name: "a bundle",
      version: "0.0.1",
      commands: %{
        test_command: %{
          executable: "/bin/foobar"}}
    }

    Map.merge(defaults, params)
  end
end
