defmodule CogApi.HTTP.Bundles do
  alias CogApi.HTTP.ApiResponse
  alias CogApi.HTTP.Base

  alias CogApi.Endpoint
  alias CogApi.Resources.Bundle

  def index(%Endpoint{}=endpoint) do
    Base.get(endpoint, "bundles")
    |> ApiResponse.format(%{"bundles" => [%Bundle{}]})
  end

  def show(%Endpoint{}=endpoint, id) do
    Base.get(endpoint, "bundles/#{id}")
    |> ApiResponse.format(%{"bundle" => %Bundle{}})
  end

  def update(%Endpoint{}=endpoint, bundle_id, %{enabled: enabled}) do
    status = Bundle.encode_status(enabled)

    Base.post(endpoint, "bundles/#{bundle_id}/status", %{status: status})
    |> format_update_response(bundle_id)
  end

  defp format_update_response(response, bundle_id) do
    {
      ApiResponse.type(response),
      build_bundle_struct(Poison.decode!(response.body), bundle_id)
    }
  end

  defp build_bundle_struct(params, bundle_id) do
    %Bundle{
      id: bundle_id,
      enabled: Bundle.decode_status(params["status"]),
      name: params["bundle"],
    }
  end
end
