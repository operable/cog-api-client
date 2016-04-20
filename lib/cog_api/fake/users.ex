defmodule CogApi.Fake.Users do
  import CogApi.Fake.Random
  import CogApi.Fake.Helpers

  alias CogApi.Endpoint
  alias CogApi.Fake.Server
  alias CogApi.Resources.User

  def index(%Endpoint{token: nil}),  do: Endpoint.invalid_endpoint
  def index(%Endpoint{}) do
    {:ok, Server.index(User)}
  end

  def show(%Endpoint{token: nil}, _),  do: Endpoint.invalid_endpoint
  def show(%Endpoint{}, %{username: username}) do
    {:ok, Server.show_by_key(User, :username, username)}
  end
  def show(%Endpoint{}, id) do
    {:ok, Server.show(User, id)}
  end

  def create(%Endpoint{token: nil}, _), do: Endpoint.invalid_endpoint
  def create(%Endpoint{token: _}, params) do
    catch_errors %User{}, params, fn ->
      new_user = %User{id: random_string(8)}
      new_user = Map.merge(new_user, params)
      {:ok, Server.create(User, new_user)}
    end
  end

  def update(%Endpoint{token: nil}, _, _), do: Endpoint.invalid_endpoint
  def update(%Endpoint{token: _}, id, params) do
    catch_errors %User{}, params, fn ->
      {:ok, Server.update(User, id, params)}
    end
  end

  def delete(%Endpoint{token: nil}, _, _), do: Endpoint.invalid_endpoint
  def delete(%Endpoint{token: _}, id), do: Server.delete(User, id)
end
