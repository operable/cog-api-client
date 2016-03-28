defmodule CogApi.HTTP.Groups do
  alias CogApi.HTTP.ApiResponse
  alias CogApi.HTTP.Base

  alias CogApi.Endpoint
  alias CogApi.Resources.Group
  alias CogApi.Resources.User

  def index(%Endpoint{}=endpoint) do
    Base.get(endpoint, "groups")
    |> ApiResponse.format(%{"groups" => [%Group{}]})
  end

  def show(%Endpoint{}=endpoint, id) do
    group_json = [
      Task.async(fn -> get_group(endpoint, id) end),
      Task.async(fn -> get_users_for_group(endpoint, id) end),
    ]

    {group_status, group} = group_json |> List.first |> Task.await
    {users_status, users} = group_json |> List.last |> Task.await

    {
      ApiResponse.type([group_status, users_status]),
      %{group | users: users}
    }
  end

  defp get_users_for_group(endpoint, id) do
    response = Base.get(endpoint, "groups/#{id}/memberships")
    json_map = %{"members" => %{"users" => [%User{}]}}
    users = Poison.decode!(response.body, as: json_map)["members"]["users"]
    {
      ApiResponse.type(response),
      users
    }
  end

  defp get_group(endpoint, id) do
    Base.get(endpoint, "groups/#{id}")
    |> ApiResponse.format(%{"group" => %Group{}})
  end

  def create(%Endpoint{}=endpoint, params) do
    Base.post(endpoint, "groups", %{group: params})
    |> ApiResponse.format(%{"group" => %Group{}})
  end

  def delete(%Endpoint{}=endpoint, group_id) do
    Base.delete(endpoint, "groups/#{group_id}")
    |> ApiResponse.format_delete("The group could not be deleted")
  end

  def add_user(%Endpoint{}=endpoint, group, user) do
    update_membership(endpoint, group, user, :add)
  end

  def remove_user(%Endpoint{}=endpoint, group, user) do
    update_membership(endpoint, group, user, :remove)
  end

  defp update_membership(endpoint, group, user, action) do
    path = "groups/#{group.id}/membership"
    Base.post(endpoint, path, %{members: %{users: %{action =>  [user.username]}}})
    |> format_membership_response(group)
  end

  defp format_membership_response(response, group) do
    json_map = %{"members" => %{"users" => [%User{}]}}
    body = Poison.decode!(response.body, as: json_map)
    {
      ApiResponse.type(response),
      %{group | users: body["members"]["users"] }
    }
  end
end
