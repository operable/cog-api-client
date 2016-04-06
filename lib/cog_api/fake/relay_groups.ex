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
  def delete(id, %Endpoint{token: _}) do
    if Server.show(RelayGroup, id) do
      Server.delete(RelayGroup, id)
      :ok
    else
      {:error, ["The relay group could not be deleted"]}
    end
  end

  def add_relay(_, _, %Endpoint{token: nil}), do: Endpoint.invalid_endpoint
  def add_relay(id, relay_id, %Endpoint{token: _}) do
    relay = Server.show(Relay, relay_id)
    relay_group = Server.show(RelayGroup, id)
    relay_with_group = %{relay | groups: relay.groups ++ [relay_group]}
    Server.update(Relay, relay.id, relay_with_group)

    relays = relay_group.relays ++ [relay_with_group]
    relay_group = %{relay_group | relays: relays}

    {:ok, Server.update(RelayGroup, id, relay_group)}
  end

  def remove_relay(_, _, %Endpoint{token: nil}), do: Endpoint.invalid_endpoint
  def remove_relay(id, relay_id, %Endpoint{token: _}) do
    relay = Server.show(Relay, relay_id)
    relay_group = Server.show(RelayGroup, id)
    relays = relay_group.relays -- [relay]
    relay_group = %{relay_group | relays: relays}

    relay_without_group = %{relay | groups: relay.groups -- [relay_group]}
    Server.update(Relay, relay.id, relay_without_group)

    {:ok, Server.update(RelayGroup, id, relay_group)}
  end
end
