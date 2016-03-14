defmodule CogApi.Fake.Roles do
  import CogApi.Fake.Random

  alias CogApi.Endpoint
  alias CogApi.Fake.Server
  alias CogApi.Resources.Role

  def role_index(%Endpoint{token: nil}),  do: invalid_endpoint
  def role_index(%Endpoint{}) do
    {:ok, Server.index(:roles)}
  end

  def role_show(%Endpoint{token: nil}, _),  do: invalid_endpoint
  def role_show(%Endpoint{}, id) do
    {:ok, Server.show(:roles, id)}
  end

  def role_create(%Endpoint{token: nil}, %{name: _}), do: invalid_endpoint
  def role_create(%Endpoint{token: _}, %{name: name}) do
    new_role = %Role{id: random_string(8), name: name}
    {:ok, Server.create(:roles, new_role)}
  end

  def role_update(%Endpoint{token: nil}, _, _), do: invalid_endpoint
  def role_update(%Endpoint{token: _}, id, params) do
    {:ok, Server.update(:roles, id, params)}
  end

  def role_delete(%Endpoint{token: nil}, _, _), do: invalid_endpoint
  def role_delete(%Endpoint{token: _}, id) do
    Server.delete(:roles, id)
    :ok
  end

  def invalid_endpoint do
    {:error, "You must provide an authenticated endpoint"}
  end
end
