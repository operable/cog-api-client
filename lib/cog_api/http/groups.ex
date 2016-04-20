defmodule CogApi.HTTP.Groups do
  alias CogApi.HTTP.ApiResponse
  alias CogApi.HTTP.Base

  alias CogApi.Endpoint
  alias CogApi.Resources.Group
  alias CogApi.Resources.Role
  alias CogApi.Decoders.Group, as: GroupDecoder

  def index(%Endpoint{}=endpoint) do
    Base.get(endpoint, "groups")
    |> format_groups_response
  end

  def show(%Endpoint{}=endpoint, id) do
    Base.get(endpoint, "groups/#{id}")
    |> format_group_response
  end

  def find(%Endpoint{}=endpoint, filter) do
    Base.get_by(endpoint, "groups", filter)
    |> format_group_response
  end

  def create(%Endpoint{}=endpoint, params) do
    Base.post(endpoint, "groups", %{group: params})
    |> ApiResponse.format(%{"group" => %Group{}})
  end

  def update(%Endpoint{}=endpoint, group_id, params) do
    Base.patch(endpoint, "groups/#{group_id}", %{"group" => params})
    |> ApiResponse.format(%{"group" => Group.format})
  end

  def delete(%Endpoint{}=endpoint, group_id) do
    Base.delete(endpoint, "groups/#{group_id}")
    |> ApiResponse.format_delete("The group could not be deleted")
  end

  def add_role(%Endpoint{}=endpoint, group, role) do
    update_roles_for_group(endpoint, group, role, :grant)
  end

  def remove_role(%Endpoint{}=endpoint, group, role) do
    update_roles_for_group(endpoint, group, role, :revoke)
  end

  def update_roles_for_group(endpoint, group, role, action) do
    path = "groups/#{group.id}/roles"
    Base.post(endpoint, path, %{roles: %{action => [role.name]}})
    |> format_response(group)
  end

  defp format_response(response, group) do
    roles = ApiResponse.parse_struct(response,  %{"roles" => [Role.format]})
    {
      ApiResponse.type(response),
      %{group | roles: roles }
    }
  end

  def add_user(%Endpoint{}=endpoint, group, user) do
    update_membership(endpoint, group, user, :add)
  end

  def remove_user(%Endpoint{}=endpoint, group, user) do
    update_membership(endpoint, group, user, :remove)
  end

  defp update_membership(endpoint, group, user, action) do
    path = "groups/#{group.id}/users"
    Base.post(endpoint, path, %{users: %{action => [user.email_address]}})
    |> format_group_response
  end

  defp format_group_response(response) do
    response
    |> ApiResponse.format_with_decoder(GroupDecoder, "group")
  end

  defp format_groups_response(response) do
    response
    |> ApiResponse.format_many_with_decoder(GroupDecoder, "groups")
  end
end
