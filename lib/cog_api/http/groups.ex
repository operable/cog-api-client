defmodule CogApi.HTTP.Groups do
  alias CogApi.HTTP.ApiResponse
  alias CogApi.HTTP.Base

  alias CogApi.Endpoint
  alias CogApi.Resources.Group
  alias CogApi.Resources.User
  alias CogApi.Decoders.Group, as: GroupDecoder

  def index(%Endpoint{}=endpoint) do
    Base.get(endpoint, "groups")
    |> format_groups_response
  end

  def show(%Endpoint{}=endpoint, id) do
    Base.get(endpoint, "groups/#{id}")
    |> format_group_response
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

  defp format_group_response(response) do
    json_structure = %{"group" => %GroupDecoder{}}
    groups = Poison.decode!(response.body, as: json_structure)["group"]
    |> GroupDecoder.to_group

    {
      ApiResponse.type(response),
      groups
    }
  end

  defp format_groups_response(response) do
    json_structure = %{"groups" => [%GroupDecoder{}]}
    groups = Poison.decode!(response.body, as: json_structure)["groups"]
    |> Enum.map(&GroupDecoder.to_group/1)

    {
      ApiResponse.type(response),
      groups
    }
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
