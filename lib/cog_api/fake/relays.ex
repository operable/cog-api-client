defmodule CogApi.Fake.Relays do
  import CogApi.Fake.Helpers
  import CogApi.Fake.Random

  alias CogApi.Endpoint
  alias CogApi.Fake.Server
  alias CogApi.Resources.Relay

  def index(%Endpoint{token: nil}),  do: Endpoint.invalid_endpoint
  def index(%Endpoint{}) do
    {:ok, Server.index(:relays)}
  end

  def show(_, %Endpoint{token: nil}),  do: Endpoint.invalid_endpoint
  def show(id, %Endpoint{}) do
    {:ok, Server.show(:relays, id)}
  end

  def create(_, %Endpoint{token: nil}), do: Endpoint.invalid_endpoint
  def create(params = %{name: name}, %Endpoint{token: _}) do
    catch_errors params, fn ->
      new_relay = %Relay{id: random_string(8), name: name}
      {:ok, Server.create(:relays, new_relay)}
    end
  end

  def update(_, _, %Endpoint{token: nil}), do: Endpoint.invalid_endpoint
  def update(id, params, %Endpoint{token: _}) do
    catch_errors params, fn ->
      {:ok, Server.update(:relays, id, params)}
    end
  end

  def delete(_, %Endpoint{token: nil}), do: Endpoint.invalid_endpoint
  def delete(id, %Endpoint{token: _}) do
    if Server.show(:relays, id) do
      Server.delete(:relays, id)
      :ok
    else
      {:error, ["The relay could not be deleted"]}
    end
  end
end
