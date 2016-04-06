defmodule CogApi.Fake.Relays do
  import CogApi.Fake.Helpers
  import CogApi.Fake.Random

  alias CogApi.Endpoint
  alias CogApi.Fake.Server
  alias CogApi.Resources.Relay

  def index(%Endpoint{token: nil}),  do: Endpoint.invalid_endpoint
  def index(%Endpoint{}) do
    {:ok, Server.index(Relay)}
  end

  def show(_, %Endpoint{token: nil}),  do: Endpoint.invalid_endpoint
  def show(%{name: name}, %Endpoint{}=endpoint) do
    relay = Server.show_by_key(Relay, :name, name)
    show(relay.id, endpoint)
  end
  def show(id, %Endpoint{}) do
    {:ok, Server.show(Relay, id)}
  end

  def create(_, %Endpoint{token: nil}), do: Endpoint.invalid_endpoint
  def create(params = %{name: _}, %Endpoint{token: _}) do
    catch_errors params, fn ->
      new_relay = %Relay{id: random_string(8)}
      new_relay = Map.merge(new_relay, params)
      {:ok, Server.create(Relay, new_relay)}
    end
  end

  def update(_, _, %Endpoint{token: nil}), do: Endpoint.invalid_endpoint
  def update(%{name: name}, params, %Endpoint{}=endpoint) do
    relay = Server.show_by_key(Relay, :name, name)
    update(relay.id, params, endpoint)
  end
  def update(id, params, %Endpoint{token: _}) do
    catch_errors params, fn ->
      {:ok, Server.update(Relay, id, params)}
    end
  end

  def delete(_, %Endpoint{token: nil}), do: Endpoint.invalid_endpoint
  def delete(%{name: name}, %Endpoint{}=endpoint) do
    relay = Server.show_by_key(Relay, :name, name)
    delete(relay.id, endpoint)
  end
  def delete(id, %Endpoint{token: _}) do
    if Server.show(Relay, id) do
      Server.delete(Relay, id)
      :ok
    else
      {:error, ["The relay could not be deleted"]}
    end
  end
end
