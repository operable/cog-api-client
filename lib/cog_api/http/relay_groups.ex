defmodule CogApi.HTTP.RelayGroups do
  alias CogApi.HTTP.ApiResponse
  alias CogApi.HTTP.Base

  alias CogApi.Endpoint
  alias CogApi.Decoders.RelayGroup, as: RelayGroupDecoder

  def index(%Endpoint{}=endpoint) do
    Base.get(endpoint, "relay_groups")
    |> ApiResponse.format_many_with_decoder(RelayGroupDecoder, "relay_groups")
  end

  def show(%{name: name}, %Endpoint{}=endpoint) do
    Base.get_by(endpoint, "relay_groups", name: name)
    |> ApiResponse.format_with_decoder(RelayGroupDecoder, "relay_group")
  end
  def show(id, %Endpoint{}=endpoint) do
    Base.get(endpoint, resource_path(id))
    |> ApiResponse.format_with_decoder(RelayGroupDecoder, "relay_group")
  end

  def create(params, %Endpoint{}=endpoint) do
    Base.post(endpoint, "relay_groups", %{relay_group: params})
    |> ApiResponse.format_with_decoder(RelayGroupDecoder, "relay_group")
  end

  def update(id, params, %Endpoint{}=endpoint) do
    Base.patch(endpoint, resource_path(id), %{relay_group: params})
    |> ApiResponse.format_with_decoder(RelayGroupDecoder, "relay_group")
  end

  def delete(%{name: name}, %Endpoint{}=endpoint) do
    Base.delete_by(endpoint, "relay_groups", name: name)
    |> ApiResponse.format_delete("The relay group `#{name}` could not be deleted")
  end
  def delete(id, %Endpoint{}=endpoint) do
    Base.delete(endpoint, resource_path(id))
    |> ApiResponse.format_delete("The relay group could not be deleted")
  end

  def update_memberships_by_name(action, relay_group_name, relay_names, endpoint) do
    relay_names = List.wrap(relay_names)
    with {:ok, relay_group} <- show(%{name: relay_group_name}, endpoint),
         {:ok, relay_ids}   <- resource_names_to_ids(:relay, relay_names, endpoint) do
      update_memberships_by_id(action, relay_group.id, relay_ids, endpoint)
    end
  end

  def update_memberships_by_id(action, relay_group_id, relay_ids, endpoint) do
    relay_ids = List.wrap(relay_ids)
    path = "relay_groups/#{relay_group_id}/relays"
    Base.post(endpoint, path, %{relays: %{action => relay_ids}})
    |> ApiResponse.format_with_decoder(RelayGroupDecoder, "relay_group")
  end

  def update_assignments_by_name(action, relay_group_name, bundle_names, endpoint) do
    bundle_names = List.wrap(bundle_names)
    with {:ok, relay_group} <- show(%{name: relay_group_name}, endpoint),
         {:ok, bundle_ids}  <- resource_names_to_ids(:bundle, bundle_names, endpoint) do
      update_assignments_by_id(action, relay_group.id, bundle_ids, endpoint)
    end
  end

  def update_assignments_by_id(action, relay_group_id, bundle_ids, endpoint) do
    bundle_ids = List.wrap(bundle_ids)
    path = "relay_groups/#{relay_group_id}/bundles"
    Base.post(endpoint, path, %{bundles: %{action => bundle_ids}})
    |> ApiResponse.format_with_decoder(RelayGroupDecoder, "relay_group")
  end

  defp resource_names_to_ids(resource_type, resource_list, endpoint) do
    get_resource_id = fn(name, acc, endpoint, resource_type) ->
      resource_name = resource_name(resource_type)
      resource_module = resource_module(resource_type)

      case Base.get_by(endpoint, resource_name, name: name)
      |> ApiResponse.format(%{Atom.to_string(resource_type) => resource_module.format}) do
        {:ok, resource} ->
          {:ok, acc} = acc
          {:cont, {:ok, [resource.id | acc]}}
        error ->
          {:halt, error}
      end
    end

    List.wrap(resource_list)
    |> Enum.reduce_while({:ok, []}, &get_resource_id.(&1, &2, endpoint, resource_type))
  end

  defp resource_path(id) do
    "relay_groups/#{id}"
  end

  defp resource_module(:bundle), do: CogApi.Resources.Bundle
  defp resource_module(:relay), do: CogApi.Resources.Relay

  defp resource_name(:bundle), do: "bundles"
  defp resource_name(:relay), do: "relays"
end
