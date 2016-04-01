defmodule CogApi.Fake.RelayGroups do
  import CogApi.Fake.Random

  alias CogApi.Endpoint
  alias CogApi.Fake.Server
  alias CogApi.Resources.RelayGroup

  def index(%Endpoint{token: nil}),  do: Endpoint.invalid_endpoint
  def index(%Endpoint{}) do
    {:ok, Server.index(:relay_groups)}
  end

  def show(_, %Endpoint{token: nil}),  do: Endpoint.invalid_endpoint
  def show(id, %Endpoint{}) do
    {:ok, Server.show(:relay_groups, id)}
  end

  def create(_, %Endpoint{token: nil}), do: Endpoint.invalid_endpoint
  def create(%{name: name}, %Endpoint{token: _}) do
    new_relay_group = %RelayGroup{id: random_string(8), name: name}
    {:ok, Server.create(:relay_groups, new_relay_group)}
  end

  def update(_, _, %Endpoint{token: nil}), do: Endpoint.invalid_endpoint
  def update(id, params, %Endpoint{token: _}) do
    {:ok, Server.update(:relay_groups, id, params)}
  end

  def delete(_, %Endpoint{token: nil}), do: Endpoint.invalid_endpoint
  def delete(id, %Endpoint{token: _}) do
    if Server.show(:relay_groups, id) do
      Server.delete(:relay_groups, id)
      :ok
    else
      {:error, ["The relay group could not be deleted"]}
    end
  end
end
