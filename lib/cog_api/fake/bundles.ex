defmodule CogApi.Fake.Bundles do
  alias CogApi.Endpoint
  alias CogApi.Fake.Server

  def index(%Endpoint{token: nil}),  do: Endpoint.invalid_endpoint
  def index(%Endpoint{}) do
    {:ok, Server.index(:bundles)}
  end
end
