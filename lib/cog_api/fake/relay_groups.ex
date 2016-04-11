defmodule CogApi.Fake.RelayGroups do
  import CogApi.Fake.Random

  alias CogApi.Endpoint
  alias CogApi.Fake.Server
  alias CogApi.Resources.Relay
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
  def create(%{name: name}, %Endpoint{token: _}) do
    new_relay_group = %RelayGroup{id: random_string(8), name: name, relays: []}
    {:ok, Server.create(RelayGroup, new_relay_group)}
  end

  def update(_, _, %Endpoint{token: nil}), do: Endpoint.invalid_endpoint
  def update(id, params, %Endpoint{token: _}) do
    {:ok, Server.update(RelayGroup, id, params)}
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
  defp delete_relay_group(_), do: {:error, ["The relay group could not be deleted"]}

  def add_relay(_, _, %Endpoint{token: nil}), do: Endpoint.invalid_endpoint
  def add_relay(%{name: name}, %{relay: relay_name}, %Endpoint{token: _}) do
    relay = Server.show_by_key(Relay, :name, relay_name)
    relay_group = Server.show_by_key(RelayGroup, :name, name)
    add_relay(relay, relay_group)
  end
  def add_relay(id, relay_id, %Endpoint{token: _}) do
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

  def remove_relay(_, _, %Endpoint{token: nil}), do: Endpoint.invalid_endpoint
  def remove_relay(%{name: name}, %{relay: relay_name}, %Endpoint{token: _}) do
    relay = Server.show_by_key(Relay, :name, relay_name)
    relay_group = Server.show_by_key(RelayGroup, :name, name)
    remove_relay(relay, relay_group)
  end
  def remove_relay(id, relay_id, %Endpoint{token: _}) do
    relay = Server.show(Relay, relay_id)
    relay_group = Server.show(RelayGroup, id)
    remove_relay(relay, relay_group)
  end

  defp remove_relay(%Relay{}=relay, %RelayGroup{}=relay_group) do
    relays = relay_group.relays -- [relay]
    relay_group = %{relay_group | relays: relays}
    relay_without_group = %{relay | groups: relay.groups -- [relay_group]}
    update_relays(relay_without_group, relay_group)
  end

  defp update_relays(relay, relay_group) do
    Server.update(Relay, relay.id, relay)
    {:ok, Server.update(RelayGroup, relay_group.id, relay_group)}
  end
end
