defmodule CogApi.Fake.Users do
  import CogApi.Fake.Random

  alias CogApi.Endpoint
  alias CogApi.Fake.Server
  alias CogApi.Resources.User

  def index(%Endpoint{token: nil}),  do: Endpoint.invalid_endpoint
  def index(%Endpoint{}) do
    {:ok, Server.index(:users)}
  end

  def show(%Endpoint{token: nil}, _),  do: Endpoint.invalid_endpoint
  def show(%Endpoint{}, id) do
    {:ok, Server.show(:users, id)}
  end

  def create(%Endpoint{token: nil}, _), do: Endpoint.invalid_endpoint
  def create(%Endpoint{token: _}, params) do
    new_user = %User{id: random_string(8)}
    new_user = Map.merge(new_user, params)
    {:ok, Server.create(:users, new_user)}
  end
end
