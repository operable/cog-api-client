defmodule CogApi.Fake.RelayGroups do
  import CogApi.Fake.Random
  import CogApi.Fake.Helpers

  alias CogApi.Endpoint
  alias CogApi.Fake.Server
  alias CogApi.Resources.Relay
  alias CogApi.Resources.Bundle
  alias CogApi.Resources.RelayGroup

  def index(%Endpoint{token: nil}),  do: Endpoint.invalid_endpoint
  def index(%Endpoint{}) do
    {:ok, Server.index(RelayGroup)}
  end

  def show(_, %Endpoint{token: nil}),  do: Endpoint.invalid_endpoint
  def show(%{name: name}, %Endpoint{}=endpoint) do
    relaygroup = Server.show_by_key(RelayGroup, :name, name)
    show(relaygroup.id, endpoint)
  end
  def show(id, %Endpoint{}) do
    {:ok, Server.show(RelayGroup, id)}
  end

  def create(_, %Endpoint{token: nil}), do: Endpoint.invalid_endpoint
  def create(params=%{name: name}, %Endpoint{token: _}) do
    catch_errors %RelayGroup{}, params, fn ->
      new_relay_group = %RelayGroup{id: random_string(8), name: name, relays: []}
      {:ok, Server.create(RelayGroup, new_relay_group)}
    end
  end

  def update(_, _, %Endpoint{token: nil}), do: Endpoint.invalid_endpoint
  def update(id, params, %Endpoint{token: _}) do
    catch_errors %RelayGroup{}, params, fn ->
      {:ok, Server.update(RelayGroup, id, params)}
    end
  end

  def delete(_, %Endpoint{token: nil}), do: Endpoint.invalid_endpoint
  def delete(%{name: name}, %Endpoint{}) do
    Server.show_by_key(RelayGroup, :name, name)
    |> delete_relay_group
  end
  def delete(id, %Endpoint{token: _}) do
    Server.show(RelayGroup, id)
    |> delete_relay_group
  end

  defp delete_relay_group(%RelayGroup{}=group) do
    Server.delete(RelayGroup, group.id)
  end
  defp delete_relay_group(_), do: return_error("The relay group could not be deleted")

  def add_relays_by_name(_, _, %Endpoint{token: nil}), do: Endpoint.invalid_endpoint
  def add_relays_by_name(name, relay_names, %Endpoint{}=endpoint) do
    relay_names = List.wrap(relay_names)
    relay_group = Server.show_by_key(RelayGroup, :name, name)
    relay_ids = Enum.map(relay_names, &Server.show_by_key(Relay, :name, &1))
    |> Enum.map(&Map.fetch!(&1, :id))
    add_relays_by_id(relay_group.id, relay_ids, endpoint)
  end

  def add_relays_by_id(_, _, %Endpoint{token: nil}), do: Endpoint.invalid_endpoint
  def add_relays_by_id(id, relay_ids, %Endpoint{}=endpoint) do
    List.wrap(relay_ids)
    |> Enum.map(&add_relay(id, &1, endpoint))
  end

  defp add_relay(id, relay_id, %Endpoint{token: _}) do
    relay = Server.show(Relay, relay_id)
    relay_group = Server.show(RelayGroup, id)
    add_relay(relay, relay_group)
  end

  defp add_relay(%Relay{}=relay, %RelayGroup{}=relay_group) do
    relay_with_group = %{relay | groups: relay.groups ++ [relay_group]}
    relays = relay_group.relays ++ [relay_with_group]
    relay_group = %{relay_group | relays: relays}
    update_relays(relay_with_group, relay_group)
  end

  def remove_relays_by_name(_, _, %Endpoint{token: nil}), do: Endpoint.invalid_endpoint
  def remove_relays_by_name(name, relay_names, %Endpoint{}=endpoint) do
    relay_names = List.wrap(relay_names)
    relay_group = Server.show_by_key(RelayGroup, :name, name)
    relay_ids = Enum.map(relay_names, &Server.show_by_key(Relay, :name, &1))
    |> Enum.map(&Map.fetch!(&1, :id))
    remove_relays_by_id(relay_group.id, relay_ids, endpoint)
  end

  def remove_relays_by_id(_, _, %Endpoint{token: nil}), do: Endpoint.invalid_endpoint
  def remove_relays_by_id(id, relay_ids, %Endpoint{token: _}=endpoint) do
    List.wrap(relay_ids)
    |> Enum.map(&remove_relay(id, &1, endpoint))
  end

  defp remove_relay(id, relay_id, %Endpoint{token: _}) do
    relay = Server.show(Relay, relay_id)
    relay_group = Server.show(RelayGroup, id)
    remove_relay(relay, relay_group)
  end

  defp remove_relay(%Relay{}=relay, %RelayGroup{}=relay_group) do
    relays = Enum.reject(relay_group.relays, &(&1.id == relay.id))
    relay_group = %{relay_group | relays: relays}

    relay_groups = Enum.reject(relay.groups, &(&1.id == relay_group.id))
    relay_without_group = %{relay | groups: relay_groups}

    update_relays(relay_without_group, relay_group)
  end

  defp update_relays(relay, relay_group) do
    Server.update(Relay, relay.id, relay)
    {:ok, Server.update(RelayGroup, relay_group.id, relay_group)}
  end

  def add_bundles_by_name(_, _, %Endpoint{token: nil}), do: Endpoint.invalid_endpoint
  def add_bundles_by_name(name, bundle_names, %Endpoint{}=endpoint) do
    bundle_names = List.wrap(bundle_names)
    relay_group = Server.show_by_key(RelayGroup, :name, name)
    bundle_ids = Enum.map(bundle_names, &Server.show_by_key(Bundle, :name, &1))
    |> Enum.map(&Map.fetch!(&1, :id))
    add_bundles_by_id(relay_group.id, bundle_ids, endpoint)
  end

  def add_bundles_by_id(_, _, %Endpoint{token: nil}), do: Endpoint.invalid_endpoint
  def add_bundles_by_id(id, bundle_ids, %Endpoint{}=endpoint) do
    List.wrap(bundle_ids)
    |> Enum.map(&add_bundle(id, &1, endpoint))
  end

  defp add_bundle(id, bundle_id, %Endpoint{}) do
    bundle = Server.show(Bundle, bundle_id)
    relay_group = Server.show(RelayGroup, id)
    add_bundle(bundle, relay_group)
  end

  defp add_bundle(%Bundle{}=bundle, %RelayGroup{}=relay_group) do
    bundle_with_group = %{bundle | relay_groups: bundle.relay_groups ++ [relay_group]}
    bundles = relay_group.bundles ++ [bundle_with_group]
    relay_group = %{relay_group | bundles: bundles}
    update_bundles(bundle_with_group, relay_group)
  end

  def remove_bundles_by_name(_, _, %Endpoint{token: nil}), do: Endpoint.invalid_endpoint
  def remove_bundles_by_name(name, bundle_names, %Endpoint{}=endpoint) do
    bundle_names = List.wrap(bundle_names)
    relay_group = Server.show_by_key(RelayGroup, :name, name)
    bundle_ids = Enum.map(bundle_names, &Server.show_by_key(Bundle, :name, &1))
    |> Enum.map(&Map.fetch!(&1, :id))
    remove_bundles_by_id(relay_group.id, bundle_ids, endpoint)
  end

  def remove_bundles_by_id(_, _, %Endpoint{token: nil}), do: Endpoint.invalid_endpoint
  def remove_bundles_by_id(id, bundle_ids, %Endpoint{}=endpoint) do
    List.wrap(bundle_ids)
    |> Enum.map(&remove_bundle(id, &1, endpoint))
  end

  defp remove_bundle(id, bundle_id, %Endpoint{token: _}) do
    bundle = Server.show(Bundle, bundle_id)
    relay_group = Server.show(RelayGroup, id)
    remove_bundle(bundle, relay_group)
  end

  defp remove_bundle(%Bundle{}=bundle, %RelayGroup{}=relay_group) do
    bundles = Enum.reject(relay_group.bundles, &(&1.id == bundle.id))
    relay_group = %{relay_group | bundles: bundles}

    relay_groups = Enum.reject(bundle.relay_groups, &(&1.id == relay_group.id))
    bundle_without_group = %{bundle | relay_groups: relay_groups}

    update_bundles(bundle_without_group, relay_group)
  end

  defp update_bundles(bundle, relay_group) do
    Server.update(Bundle, bundle.id, bundle)
    {:ok, Server.update(RelayGroup, relay_group.id, relay_group)}
  end
end
