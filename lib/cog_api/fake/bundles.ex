defmodule CogApi.Fake.Bundles do
  alias CogApi.Endpoint
  alias CogApi.Fake.Server

  def index(%Endpoint{token: nil}),  do: Endpoint.invalid_endpoint
  def index(%Endpoint{}) do
    {:ok, Server.index(:bundles)}
  end

  def update(%Endpoint{token: _}, id, %{enabled: enabled}) do
    current_bundle = Server.show(:bundles, id)
    updated_bundle = %{current_bundle | enabled: enabled}

    {:ok, Server.update(:bundles, id, updated_bundle)}
  end

  def update(%Endpoint{token: _}, _, %{}) do
    {:error, "You can only enable or disable a bundle"}
  end
end
