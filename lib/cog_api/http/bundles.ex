defmodule CogApi.HTTP.Bundles do
  alias CogApi.HTTP.ApiResponse
  alias CogApi.HTTP.Base
  alias CogApi.HTTP.Rules

  alias CogApi.Endpoint
  alias CogApi.Resources.Bundle
  alias CogApi.Decoders.Bundle, as: BundleDecoder

  def index(%Endpoint{}=endpoint) do
    Base.get(endpoint, "bundles")
    |> ApiResponse.format_many_with_decoder(BundleDecoder, "bundles")
  end

  def show(%Endpoint{}=endpoint, id) do
    case find_bundle(endpoint, id) do
      {:ok, bundle} -> add_rules(endpoint, bundle)
      other_response -> other_response
    end
  end

  def delete(%Endpoint{}=endpoint, id) do
    Base.delete(endpoint, "bundles/#{id}")
    |> ApiResponse.format_delete("The bundle could not be deleted")
  end

  def create(%Endpoint{}=endpoint, params) do
    Base.post(endpoint, "bundles", %{bundle: %{config: params}})
    |> ApiResponse.format_with_decoder(BundleDecoder, "bundle")
  end

  defp find_bundle(endpoint, id) do
    Base.get(endpoint, "bundles/#{id}")
    |> ApiResponse.format_with_decoder(BundleDecoder, "bundle")
  end

  defp add_rules(endpoint, bundle) do
    commands = bundle.commands
    |> Enum.map(fn command -> %{command | rules: find_rules(endpoint, bundle, command)} end)

    {:ok, %{bundle | commands: commands}}
  end

  defp find_rules(endpoint, bundle, command) do
    full_command_name = "#{bundle.name}:#{command.name}"
    {:ok, rules} = Rules.index(full_command_name, endpoint)
    rules
  end

  def update(%Endpoint{}=endpoint, %{name: bundle_name}, status) do
    with {:ok, bundle_id} = Base.find_id_by(endpoint, "bundles", name: bundle_name) do
      update(endpoint, bundle_id, status)
    end
  end
  def update(%Endpoint{}=endpoint, bundle_id, %{enabled: enabled}) do
    status = Bundle.encode_status(enabled)

    Base.post(endpoint, "bundles/#{bundle_id}/status", %{status: status})
    |> format_update_response(bundle_id)
  end

  defp format_update_response(response, bundle_id) do
    if response.status_code == 400 do
      ApiResponse.format_error(response)
    else
      {
        ApiResponse.type(response),
        build_bundle_struct(Poison.decode!(response.body), bundle_id)
      }
    end
  end

  defp build_bundle_struct(params, bundle_id) do
    %Bundle{
      id: bundle_id,
      enabled: Bundle.decode_status(params["status"]),
      name: params["bundle"],
    }
  end
end
