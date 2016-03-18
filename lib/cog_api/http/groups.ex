defmodule CogApi.HTTP.Groups do
  alias CogApi.HTTP.Base

  alias CogApi.Endpoint
  alias CogApi.Resources.Group
  alias CogApi.Resources.User

  def index(%Endpoint{}=endpoint) do
    Base.get(endpoint, "groups") |> Base.format_response("groups", [%Group{}])
  end

  def show(%Endpoint{}=endpoint, id) do
    group_json = [
      Task.async(fn -> get_group(endpoint, id) end),
      Task.async(fn -> get_users_for_group(endpoint, id) end),
    ]

    {group_status, group} = group_json |> List.first |> Task.await
    {users_status, users} = group_json |> List.last |> Task.await

    {
      Base.response_type([group_status, users_status]),
      %{group | users: users}
    }
  end

  defp get_users_for_group(endpoint, id) do
    response = Base.get(endpoint, "groups/#{id}/memberships")
    json_map = %{"members" => %{"users" => [%User{}]}}
    users = Poison.decode!(response.body, as: json_map)["members"]["users"]
    {
      Base.response_type(response),
      users
    }
  end

  defp get_group(endpoint, id) do
    Base.get(endpoint, "groups/#{id}")
    |> Base.format_response("group", %Group{})
  end

  def create(%Endpoint{}=endpoint, params) do
    Base.post(endpoint, "groups", %{group: params})
    |> Base.format_response("group", %Group{})
  end

  def add_user(%Endpoint{}=endpoint, group, user) do
    path = "groups/#{group.id}/membership"
    Base.post(endpoint, path, %{members: %{users: %{add: [user.username]}}})
    |> format_add_user_response(group)
  end

  defp format_add_user_response(response, group) do
    json_map = %{"members" => %{"users" => [%User{}]}}
    body = Poison.decode!(response.body, as: json_map)
    {
      Base.response_type(response),
      %{group | users: body["members"]["users"] }
    }
  end
end
