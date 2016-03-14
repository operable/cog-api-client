defmodule CogApi.Fake.Roles do
  import CogApi.Fake.Random

  alias CogApi.Endpoint
  alias CogApi.Fake.Server
  alias CogApi.Resources.Role

  def role_index(%Endpoint{token: nil}),  do: invalid_endpoint
  def role_index(%Endpoint{}) do
    {:ok, Server.role_index}
  end

  def role_show(%Endpoint{token: nil}, _),  do: invalid_endpoint
  def role_show(%Endpoint{}, id) do
    {:ok, Server.role_show(id)}
  end
  def role_create(%Endpoint{token: nil}, %{name: _}), do: invalid_endpoint
  def role_create(%Endpoint{token: _}, %{name: name}) do
    new_role = %Role{id: random_string(8), name: name}
    {:ok, Server.role_create(new_role)}
  end

  def invalid_endpoint do
    {:error, "You must provide an authenticated endpoint"}
  end
end
