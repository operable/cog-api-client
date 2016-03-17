defmodule CogApi.HTTP.Roles do
  alias CogApi.Endpoint
  alias CogApi.HTTP.Base
  alias CogApi.Resources.Role

  def index(%Endpoint{}=endpoint) do
    Base.get(endpoint, "roles") |> Base.format_response("roles", [%Role{}])
  end

  def show(%Endpoint{}=endpoint, id) do
    Base.get(endpoint, "roles/#{id}") |> Base.format_response("role", %Role{})
  end

  def create(%Endpoint{}=endpoint, params) do
    Base.post(endpoint, "roles", %{"role" => params})
    |> Base.format_response("role", %Role{})
  end

  def update(%Endpoint{}=endpoint, role_id, params) do
    Base.patch(endpoint, "roles/#{role_id}", %{"role" => params})
    |> Base.format_response("role", %Role{})
  end

  def delete(%Endpoint{}=endpoint, role_id) do
    Base.delete(endpoint, "roles/#{role_id}") |> Base.format_response("role", %Role{})
  end

  def grant(%Endpoint{}=endpoint, role, group) do
    update_roles_for_group(endpoint, role, group, :grant)
  end

  def revoke(%Endpoint{}=endpoint, role, group) do
    update_roles_for_group(endpoint, role, group, :revoke)
  end

  def update_roles_for_group(endpoint, role, group, action) do
    path = "groups/#{group.id}/roles"
    Base.post(endpoint, path, %{roles: %{action => [role.name]}})
    |> format_response(group)
  end

  defp format_response(response, group) do
    body = Poison.decode!(response.body, as: %{"roles" => [%Role{}]})
    {
      Base.response_type(response),
      %{group | roles: body["roles"] }
    }
  end
end
