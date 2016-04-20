defmodule CogApi.Fake.Roles do
  import CogApi.Fake.Helpers
  import CogApi.Fake.Random

  alias CogApi.Endpoint
  alias CogApi.Fake.Server
  alias CogApi.Resources.Group
  alias CogApi.Resources.Permission
  alias CogApi.Resources.Role

  def index(%Endpoint{token: nil}),  do: Endpoint.invalid_endpoint
  def index(%Endpoint{}) do
    {:ok, Server.index(Role) |> Enum.map(&(prepare_role(&1)))}
  end

  def show(%Endpoint{token: nil}, _),  do: Endpoint.invalid_endpoint
  def show(%Endpoint{}, %{name: name}) do
    {:ok, prepare_role(Server.show_by_key(Role, :name, name))}
  end
  def show(%Endpoint{}, id) do
    {:ok, prepare_role(Server.show(Role, id))}
  end

  def create(%Endpoint{token: nil}, %{name: _}), do: Endpoint.invalid_endpoint
  def create(%Endpoint{token: _}, %{name: name}=params) do
    catch_errors %Role{}, params, fn ->
      new_role = %Role{id: random_string(8), name: name}
      {:ok, Server.create(Role, new_role)}
    end
  end

  def update(%Endpoint{token: nil}, _, _), do: Endpoint.invalid_endpoint
  def update(%Endpoint{token: _}, id, params) do
    catch_errors %Role{}, params, fn ->
      {:ok, Server.update(Role, id, params) |> prepare_role}
    end
  end

  def delete(%Endpoint{token: nil}, _, _), do: Endpoint.invalid_endpoint
  def delete(%Endpoint{token: _}, id), do: Server.delete(Role, id)

  def add_permission(%Endpoint{token: nil}, _, _), do: Endpoint.invalid_endpoint
  def add_permission(%Endpoint{}, role, permission) do
    if found_permission  = matching_permission(Server.index(Permission), permission) do
      role = %{role | permissions: role.permissions ++ [found_permission]}
      {:ok, Server.update(Role, role.id, role) |> prepare_role}
    else
      return_error("Not found permissions - #{Permission.full_name(permission)}")
    end
  end

  def remove_permission(%Endpoint{token: nil}, _, _), do: Endpoint.invalid_endpoint
  def remove_permission(%Endpoint{}, role, permission) do
    if permission = matching_permission(Server.index(Permission), permission) do
      role = %{role | permissions: List.delete(role.permissions, permission)}
      {:ok, Server.update(Role, role.id, role) |> prepare_role}
    end
  end

  defp matching_permission(haystack, needle) do
    haystack
    |> Enum.find(fn permission -> permissions_match?(permission, needle) end)
  end

  defp permissions_match?(%Permission{} = permission, %Permission{} = match) do
    permission.namespace == match.namespace && permission.name == match.name
  end

  defp prepare_role(role) do
    groups = Server.index(Group)
    |> Enum.filter(fn group -> Enum.member?(group.roles, role) end)

    %{role | groups: groups}
  end
end
