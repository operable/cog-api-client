defmodule CogApi.Fake.Groups do
  import CogApi.Fake.Random

  alias CogApi.Endpoint
  alias CogApi.Fake.Server
  alias CogApi.Resources.Group

  def index(%Endpoint{token: nil}),  do: Endpoint.invalid_endpoint
  def index(%Endpoint{}) do
    {:ok, Server.index(:groups)}
  end

  def create(%Endpoint{token: nil}, _), do: Endpoint.invalid_endpoint
  def create(%Endpoint{token: _}, %{name: name}) do
    new_group = %Group{id: random_string(8), name: name}
    {:ok, Server.create(:groups, new_group)}
  end
end
