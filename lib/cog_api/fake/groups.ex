defmodule CogApi.Fake.Groups do
  import CogApi.Fake.Random

  alias CogApi.Endpoint
  alias CogApi.Fake.Server
  alias CogApi.Resources.Group

  def index(%Endpoint{token: nil}),  do: Endpoint.invalid_endpoint
  def index(%Endpoint{}) do
    {:ok, Server.index(:groups)}
  end

  def show(%Endpoint{token: nil}, _), do: Endpoint.invalid_endpoint
  def show(%Endpoint{token: _}, id) do
    {:ok, Server.show(:groups, id)}
  end

  def create(%Endpoint{token: nil}, _), do: Endpoint.invalid_endpoint
  def create(%Endpoint{token: _}, %{name: name}) do
    new_group = %Group{id: random_string(8), name: name}
    {:ok, Server.create(:groups, new_group)}
  end

  def add_user(%Endpoint{token: nil}, _, _), do: Endpoint.invalid_endpoint
  def add_user(%Endpoint{token: _}, group, user) do
    user = Server.show_by_key(:users, :username, user.username)
    group = Server.show(:groups, group.id)
    users = group.users ++ [user]
    group = %{group | users: users}

    {:ok, Server.update(:groups, group.id, group)}
  end

  def remove_user(%Endpoint{token: nil}, _, _), do: Endpoint.invalid_endpoint
  def remove_user(%Endpoint{token: _}, group, user) do
    user = Server.show_by_key(:users, :username, user.username)
    group = Server.show(:groups, group.id)
    users = group.users -- [user]
    group = %{group | users: users}

    {:ok, Server.update(:groups, group.id, group)}
  end
end
