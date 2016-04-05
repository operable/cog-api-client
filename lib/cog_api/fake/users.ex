defmodule CogApi.Fake.Users do
  import CogApi.Fake.Random
  import CogApi.Fake.Helpers

  alias CogApi.Endpoint
  alias CogApi.Fake.Server
  alias CogApi.Resources.User

  def index(%Endpoint{token: nil}),  do: Endpoint.invalid_endpoint
  def index(%Endpoint{}) do
    {:ok, Server.index(User.fake_server_information)}
  end

  def show(%Endpoint{token: nil}, _),  do: Endpoint.invalid_endpoint
  def show(%Endpoint{}, id) do
    {:ok, Server.show(User.fake_server_information, id)}
  end

  def create(%Endpoint{token: nil}, _), do: Endpoint.invalid_endpoint
  def create(%Endpoint{token: _}, params) do
    catch_errors params, fn ->
      new_user = %User{id: random_string(8)}
      new_user = Map.merge(new_user, params)
      {:ok, Server.create(User.fake_server_information, new_user)}
    end
  end

  def update(%Endpoint{token: nil}, _, _), do: Endpoint.invalid_endpoint
  def update(%Endpoint{token: _}, id, params) do
    catch_errors params, fn ->
      {:ok, Server.update(User.fake_server_information, id, params)}
    end
  end

  def delete(%Endpoint{token: nil}, _, _), do: Endpoint.invalid_endpoint
  def delete(%Endpoint{token: _}, id) do
    Server.delete(User.fake_server_information, id)
    :ok
  end
end
