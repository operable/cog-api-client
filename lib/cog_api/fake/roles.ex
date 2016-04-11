defmodule CogApi.Fake.Roles do
  import CogApi.Fake.Random

  alias CogApi.Endpoint
  alias CogApi.Fake.Server
  alias CogApi.Resources.Group
  alias CogApi.Resources.Permission
  alias CogApi.Resources.Role

  def index(%Endpoint{token: nil}),  do: Endpoint.invalid_endpoint
  def index(%Endpoint{}) do
    {:ok, Server.index(Role)}
  end

  def show(%Endpoint{token: nil}, _),  do: Endpoint.invalid_endpoint
  def show(%Endpoint{}, %{name: name}) do
    {:ok, Server.show_by_key(Role, :name, name)}
  end
  def show(%Endpoint{}, id) do
    {:ok, Server.show(Role, id)}
  end

  def create(%Endpoint{token: nil}, %{name: _}), do: Endpoint.invalid_endpoint
  def create(%Endpoint{token: _}, %{name: name}) do
    new_role = %Role{id: random_string(8), name: name}
    {:ok, Server.create(Role, new_role)}
  end

  def update(%Endpoint{token: nil}, _, _), do: Endpoint.invalid_endpoint
  def update(%Endpoint{token: _}, id, params) do
    {:ok, Server.update(Role, id, params)}
  end

  def delete(%Endpoint{token: nil}, _, _), do: Endpoint.invalid_endpoint
  def delete(%Endpoint{token: _}, id) do
    Server.delete(Role, id)
    :ok
  end

  def grant(%Endpoint{token: nil}, _, _), do: Endpoint.invalid_endpoint
  def grant(%Endpoint{}, role, group) do
    group = %{group | roles: group.roles ++ [role]}
    {:ok, Server.update(Group, group.id, group)}
  end

  def revoke(%Endpoint{token: nil}, _, _), do: Endpoint.invalid_endpoint
  def revoke(%Endpoint{}, role, group) do
    group = %{group | roles: List.delete(group.roles, role)}
    {:ok, Server.update(Group, group.id, group)}
  end

  def add_permission(%Endpoint{token: nil}, _, _), do: Endpoint.invalid_endpoint
  def add_permission(%Endpoint{}, role, permission) do
    if found_permission  = matching_permission(Server.index(Permission), permission) do
      role = %{role | permissions: role.permissions ++ [found_permission]}
      {:ok, Server.update(Role, role.id, role)}
    else
      {:error, ["Not found permissions - #{Permission.full_name(permission)}"]}
    end
  end

  def remove_permission(%Endpoint{token: nil}, _, _), do: Endpoint.invalid_endpoint
  def remove_permission(%Endpoint{}, role, permission) do
    if permission = matching_permission(Server.index(Permission), permission) do
      role = %{role | permissions: List.delete(role.permissions, permission)}
      {:ok, Server.update(Role, role.id, role)}
    end
  end

  defp matching_permission(haystack, needle) do
    haystack
    |> Enum.find(fn permission -> permissions_match?(permission, needle) end)
  end

  defp permissions_match?(%Permission{} = permission, %Permission{} = match) do
    permission.namespace == match.namespace && permission.name == match.name
  end
end
