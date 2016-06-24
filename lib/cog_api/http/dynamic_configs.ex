defmodule CogApi.HTTP.DynamicConfig do
  alias CogApi.HTTP.ApiResponse
  alias CogApi.HTTP.Base

  alias CogApi.Endpoint
  alias CogApi.Resources.DynamicConfig

  def show(%{name: name}, %Endpoint{}=endpoint) do
    Base.get_by(endpoint, "bundles", name: name)
    |> ApiResponse.format(%{"dynamic_config" => DynamicConfig.format})
  end
  def show(id, %Endpoint{}=endpoint) do
    Base.get(endpoint, resource_path(id))
    |> ApiResponse.format(%{"dynamic_config" => DynamicConfig.format})
  end

  def create(params, %Endpoint{}=endpoint) do
    Base.post(endpoint, "dynamic_config", %{dynamic_config: params})
    |> ApiResponse.format(%{"relay" => Relay.format})
  end

  def delete(%{name: name}, %Endpoint{}=endpoint) do
    Base.delete_by(endpoint, "relays", name: name)
    |> ApiResponse.format_delete("The relay `#{name}` could not be deleted")
  end
  def delete(id, %Endpoint{}=endpoint) do
    Base.delete(endpoint, resource_path(id))
    |> ApiResponse.format_delete("The relay could not be deleted")
  end

  defp resource_path(id) do
    "bundles/#{id}/dynamic_configs"
  end
end
