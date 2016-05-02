defmodule CogApi.Test.FakeHelpers do
  import CogApi.TestHelpers

  alias CogApi.Endpoint
  alias CogApi.Fake.Client

  def valid_endpoint(opts \\ %{}) do
    {:ok, endpoint} = %Endpoint{}
    |> Map.merge(opts)
    |> Client.authenticate

    endpoint
  end

  def create_bundle(params \\ %{}) do
    {:ok, bundle} = Client.bundle_create(valid_endpoint, %{config: bundle_config(params)})
    bundle
  end
end
