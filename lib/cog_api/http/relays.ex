defmodule CogApi.HTTP.Relays do
  alias CogApi.HTTP.ApiResponse
  alias CogApi.HTTP.Base

  alias CogApi.Endpoint
  alias CogApi.Resources.Relay

  def index(%Endpoint{}=endpoint) do
    Base.get(endpoint, "relays")
    |> ApiResponse.format(%{"relays" => [%Relay{}]})
  end

  def show(id, %Endpoint{}=endpoint) do
    Base.get(endpoint, resource_path(id))
    |> ApiResponse.format(%{"relay" => %Relay{}})
  end

  def create(params, %Endpoint{}=endpoint) do
    Base.post(endpoint, "relays", %{relay: params})
    |> ApiResponse.format(%{"relay" => %Relay{}})
  end

  def update(id, params, %Endpoint{}=endpoint) do
    Base.patch(endpoint, resource_path(id), %{relay: params})
    |> ApiResponse.format(%{"relay" => %Relay{}})
  end

  def delete(id, %Endpoint{}=endpoint) do
    Base.delete(endpoint, resource_path(id))
    |> ApiResponse.format_delete("The relay could not be deleted")
  end

  defp resource_path(id) do
    "relays/#{id}"
  end
end
