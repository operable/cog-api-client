defmodule CogApi.Fake.Roles do
  import CogApi.Fake.Random

  alias CogApi.Endpoint
  alias CogApi.Fake.Server
  alias CogApi.Resources.Role

  def index(%Endpoint{token: nil}),  do: Endpoint.invalid_endpoint
  def index(%Endpoint{}) do
    {:ok, Server.index(:roles)}
  end

  def show(%Endpoint{token: nil}, _),  do: Endpoint.invalid_endpoint
  def show(%Endpoint{}, id) do
    {:ok, Server.show(:roles, id)}
  end

  def create(%Endpoint{token: nil}, %{name: _}), do: Endpoint.invalid_endpoint
  def create(%Endpoint{token: _}, %{name: name}) do
    new_role = %Role{id: random_string(8), name: name}
    {:ok, Server.create(:roles, new_role)}
  end

  def update(%Endpoint{token: nil}, _, _), do: Endpoint.invalid_endpoint
  def update(%Endpoint{token: _}, id, params) do
    {:ok, Server.update(:roles, id, params)}
  end

  def delete(%Endpoint{token: nil}, _, _), do: Endpoint.invalid_endpoint
  def delete(%Endpoint{token: _}, id) do
    Server.delete(:roles, id)
    :ok
  end

  def grant(%Endpoint{token: nil}, _, _), do: Endpoint.invalid_endpoint
  def grant(%Endpoint{}, role, group) do
    group = %{group | roles: group.roles ++ [role]}
    {:ok, Server.update(:groups, group.id, group)}
  end

  def revoke(%Endpoint{token: nil}, _, _), do: Endpoint.invalid_endpoint
  def revoke(%Endpoint{}, role, group) do
    group = %{group | roles: List.delete(group.roles, role)}
    {:ok, Server.update(:groups, group.id, group)}
  end
end
