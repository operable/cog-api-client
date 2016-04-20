defmodule CogApi.HTTP.Permissions do
  alias CogApi.Endpoint
  alias CogApi.HTTP.ApiResponse
  alias CogApi.HTTP.Base
  alias CogApi.Resources.Permission

  def index(%Endpoint{}=endpoint) do
    Base.get(endpoint, "permissions")
    |> ApiResponse.format(%{"permissions" => [%Permission{}]})
  end

  def create(%Endpoint{}=endpoint, name) do
    Base.post(endpoint, "permissions", %{"permission" => %{"name" => name}})
    |> ApiResponse.format(%{"permission" => %Permission{}})
  end

  def delete(%Endpoint{}=endpoint, id) do
    Base.delete(endpoint, "permissions/#{id}")
    |> ApiResponse.format(%{"permission" => Permission.format})
  end
end
