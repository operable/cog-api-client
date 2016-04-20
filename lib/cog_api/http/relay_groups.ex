defmodule CogApi.HTTP.RelayGroups do
  alias CogApi.HTTP.ApiResponse
  alias CogApi.HTTP.Base

  alias CogApi.Endpoint
  alias CogApi.Resources.RelayGroup

  def index(%Endpoint{}=endpoint) do
    Base.get(endpoint, "relay_groups")
    |> ApiResponse.format(%{"relay_groups" => [RelayGroup.format]})
  end

  def show(%{name: name}, %Endpoint{}=endpoint) do
    Base.get_by(endpoint, "relay_groups", name: name)
    |> ApiResponse.format(%{"relay_group" => RelayGroup.format})
  end
  def show(id, %Endpoint{}=endpoint) do
    Base.get(endpoint, resource_path(id))
    |> ApiResponse.format(%{"relay_group" => RelayGroup.format})
  end

  def create(params, %Endpoint{}=endpoint) do
    Base.post(endpoint, "relay_groups", %{relay_group: params})
    |> ApiResponse.format(%{"relay_group" => RelayGroup.format})
  end

  def update(id, params, %Endpoint{}=endpoint) do
    Base.patch(endpoint, resource_path(id), %{relay_group: params})
    |> ApiResponse.format(%{"relay_group" => RelayGroup.format})
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
         {:ok, relay_ids}   <- get_relay_ids(relay_names, endpoint) do
      update_memberships_by_id(action, relay_group.id, relay_ids, endpoint)
    end
  end

  def update_memberships_by_id(action, relay_group_id, relay_ids, endpoint) do
    relay_ids = List.wrap(relay_ids)
    path = "relay_groups/#{relay_group_id}/relays"
    Base.post(endpoint, path, %{relays: %{action => relay_ids}})
    |> ApiResponse.format(%{"relay_group" => RelayGroup.format})
  end

  def update_assignments_by_name(action, relay_group_name, bundle_names, endpoint) do
    bundle_names = List.wrap(bundle_names)
    with {:ok, relay_group} <- show(%{name: relay_group_name}, endpoint),
         {:ok, bundle_ids}  <- get_bundle_ids(bundle_names, endpoint) do
      update_assignments_by_id(action, relay_group.id, bundle_ids, endpoint)
    end
  end

  def update_assignments_by_id(action, relay_group_id, bundle_ids, endpoint) do
    bundle_ids = List.wrap(bundle_ids)
    path = "relay_groups/#{relay_group_id}/bundles"
    Base.post(endpoint, path, %{bundles: %{action => bundle_ids}})
    |> ApiResponse.format(%{"relay_group" => RelayGroup.format})
  end

  defp get_relay_ids(relay_names, endpoint) when is_list(relay_names) do
    get_relay_id = fn(name, acc, endpoint) ->
      case Base.get_by(endpoint, "relays", name: name)
      |> ApiResponse.format(%{"relay" => CogApi.Resources.Relay.format}) do
        {:ok, relay} ->
          {:cont, [relay.id | acc]}
        error ->
          {:halt, error}
      end
    end

    case Enum.reduce_while(relay_names, [], &get_relay_id.(&1, &2, endpoint)) do
      relay_ids when is_list(relay_ids) ->
        {:ok, relay_ids}
      error ->
        error
    end
  end
  defp get_relay_ids(relay_name, endpoint),
    do: get_relay_ids([relay_name], endpoint)

  defp get_bundle_ids(bundle_names, endpoint) when is_list(bundle_names) do
    get_bundle_id = fn(name, acc, endpoint) ->
      case Base.get_by(endpoint, "bundles", name: name)
      |> ApiResponse.format(%{"bundle" => CogApi.Resources.Bundle.format}) do
        {:ok, bundle} ->
          {:cont, [bundle.id | acc]}
        error ->
          {:halt, error}
      end
    end

    case Enum.reduce_while(bundle_names, [], &get_bundle_id.(&1, &2, endpoint)) do
      bundle_ids when is_list(bundle_ids) ->
        {:ok, bundle_ids}
      error ->
        error
    end
  end
  defp get_bundle_ids(bundle_name, endpoint),
    do: get_bundle_ids([bundle_name], endpoint)

  defp resource_path(id) do
    "relay_groups/#{id}"
  end
end
