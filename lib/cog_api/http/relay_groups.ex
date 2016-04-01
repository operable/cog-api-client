defmodule CogApi.HTTP.RelayGroups do
  alias CogApi.HTTP.ApiResponse
  alias CogApi.HTTP.Base

  alias CogApi.Endpoint
  alias CogApi.Resources.RelayGroup

  def index(%Endpoint{}=endpoint) do
    Base.get(endpoint, "relay_groups")
    |> ApiResponse.format(%{"relay_groups" => [%RelayGroup{}]})
  end

  def show(id, %Endpoint{}=endpoint) do
    Base.get(endpoint, resource_path(id))
    |> ApiResponse.format(%{"relay_group" => %RelayGroup{}})
  end

  def create(params, %Endpoint{}=endpoint) do
    Base.post(endpoint, "relay_groups", %{relay_group: params})
    |> ApiResponse.format(%{"relay_group" => %RelayGroup{}})
  end

  def update(id, params, %Endpoint{}=endpoint) do
    Base.patch(endpoint, resource_path(id), %{relay_group: params})
    |> ApiResponse.format(%{"relay_group" => %RelayGroup{}})
  end

  def delete(id, %Endpoint{}=endpoint) do
    Base.delete(endpoint, resource_path(id))
    |> ApiResponse.format_delete("The relay group could not be deleted")
  end

  defp resource_path(id) do
    "relay_groups/#{id}"
  end
end
