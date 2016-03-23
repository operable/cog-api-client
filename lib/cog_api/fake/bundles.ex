defmodule CogApi.Fake.Bundles do
  import CogApi.Fake.Random

  alias CogApi.Endpoint
  alias CogApi.Fake.Server
  alias CogApi.Resources.Bundle

  def index(%Endpoint{token: nil}),  do: Endpoint.invalid_endpoint
  def index(%Endpoint{}) do
    {:ok, Server.index(:bundles)}
  end

  def create(%Endpoint{token: nil}, %{name: _}), do: Endpoint.invalid_endpoint
  def create(%Endpoint{token: _}, %Bundle{}=bundle) do
    new_bundle = %{bundle | id: random_string(8)}
    {:ok, Server.create(:bundles, new_bundle)}
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
