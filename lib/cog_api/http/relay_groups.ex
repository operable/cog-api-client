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

  def add_relay(%{name: name}, %{relay: relay_name}, %Endpoint{}=endpoint) do
    {relay, relay_group} = get_group_relay(name, relay_name, endpoint)
    update_membership(relay_group.id, relay.id, :add, endpoint)
  end
  def add_relay(relay_group_id, relay_id, %Endpoint{}=endpoint) do
    update_membership(relay_group_id, relay_id, :add, endpoint)
  end

  def remove_relay(%{name: name}, %{relay: relay_name}, %Endpoint{}=endpoint) do
    {relay, relay_group} = get_group_relay(name, relay_name, endpoint)
    update_membership(relay_group.id, relay.id, :remove, endpoint)
  end
  def remove_relay(relay_group_id, relay_id, %Endpoint{}=endpoint) do
    update_membership(relay_group_id, relay_id, :remove, endpoint)
  end

  defp get_group_relay(name, relay_name, endpoint) do
    with {:ok, relay} <- Base.get_by(endpoint, "relays", name: relay_name)
        |> ApiResponse.format(%{"relay" => CogApi.Resources.Relay.format}),
      {:ok, relay_group} <- show(%{name: name}, endpoint),
    do: {relay, relay_group}
  end

  defp update_membership(relay_group_id, relay_id, action, endpoint) do
    path = "relay_groups/#{relay_group_id}/membership"
    Base.post(endpoint, path, %{relays: %{action =>  [relay_id]}})
    |> ApiResponse.format(%{"relay_group" => RelayGroup.format})
  end

  def assign_bundles(%{name: name}, %{bundles: bundle_names}, endpoint) do
    with {:ok, relay_group} <- show(%{name: name}, endpoint),
         {:ok, bundle_ids}  <- get_bundle_ids(bundle_names, endpoint) do
      update_assignments(relay_group.id, bundle_ids, :add, endpoint)
    end
  end
  def assign_bundles(relay_group_id, bundle_ids, %Endpoint{}=endpoint) do
    update_assignments(relay_group_id, bundle_ids, :add, endpoint)
  end

  def remove_bundle(%{name: name}, %{bundle: bundle_name}, %Endpoint{}=endpoint) do
    case get_relay_bundle(name, bundle_name, endpoint) do
      {:ok, relay_group, bundle} ->
        update_assignments(relay_group.id, bundle.id, :remove, endpoint)
      error ->
        error
    end
  end
  def remove_bundle(relay_group_id, bundle_id, %Endpoint{}=endpoint) do
    update_assignments(relay_group_id, bundle_id, :remove, endpoint)
  end

  defp get_bundle_ids(bundle_names, endpoint), when is_list(bundle_names) do
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
  defp get_bundle_ids((bundle_name, endpoint),
    do: get_bundle_ids([bundle_name], endpoint)

  defp get_relay_bundle(name, bundle_name, endpoint) do
    with {:ok, bundle} <- Base.get_by(endpoint, "bundles", name: bundle_name)
        |> ApiResponse.format(%{"bundle" => CogApi.Resources.Bundle.format}),
      {:ok, relay_group} <- show(%{name: name}, endpoint),
      do: {:ok, relay_group, bundle}
  end

  defp update_assignments(relay_group_id, bundle_ids, action, endpoint) when is_list(bundle_ids) do
    path = "relay_groups/#{relay_group_id}/assignment"
    Base.post(endpoint, path, %{bundles: %{action =>  bundle_ids}})
    |> ApiResponse.format(%{"relay_group" => RelayGroup.format})
  end
  defp update_assignments(relay_group_id, bundle_id, action, endpoint),
    do: update_assignments(relay_group_id, [bundle_id], action, endpoint)

  defp resource_path(id) do
    "relay_groups/#{id}"
  end
end
