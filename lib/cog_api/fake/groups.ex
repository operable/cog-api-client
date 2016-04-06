defmodule CogApi.Fake.Groups do
  import CogApi.Fake.Random
  import CogApi.Fake.Helpers

  alias CogApi.Endpoint
  alias CogApi.Fake.Server
  alias CogApi.Resources.Group
  alias CogApi.Resources.User

  def index(%Endpoint{token: nil}),  do: Endpoint.invalid_endpoint
  def index(%Endpoint{}) do
    {:ok, Server.index(Group)}
  end

  def show(%Endpoint{token: nil}, _), do: Endpoint.invalid_endpoint
  def show(%Endpoint{token: _}, id) do
    {:ok, Server.show(Group, id)}
  end

  def find(%Endpoint{token: nil}, _), do: Endpoint.invalid_endpoint
  def find(%Endpoint{token: _}, params) do
    groups = Server.index(Group)
    case Enum.find(groups, &(&1.name == params[:name])) do
      nil ->
        {:error, "Group not found"}
      group ->
        {:ok, group}
    end
  end

  def create(%Endpoint{token: nil}, _), do: Endpoint.invalid_endpoint
  def create(%Endpoint{token: _}, %{name: name}) do
    new_group = %Group{id: random_string(8), name: name}
    {:ok, Server.create(Group, new_group)}
  end

  def update(%Endpoint{token: nil}, _), do: Endpoint.invalid_endpoint
  def update(%Endpoint{token: _}, id, %{name: _name}=params) do
    catch_errors params, fn ->
      {:ok, Server.update(Group, id, params)}
    end
  end

  def delete(%Endpoint{token: nil}, _, _), do: Endpoint.invalid_endpoint
  def delete(%Endpoint{token: _}, id) do
    if Server.show(Group, id) do
      Server.delete(Group, id)
      :ok
    else
      {:error, ["The group could not be deleted"]}
    end
  end

  def add_user(%Endpoint{token: nil}, _, _), do: Endpoint.invalid_endpoint
  def add_user(%Endpoint{token: _}, group, user) do
    user = Server.show_by_key(User, :email_address, user.email_address)
    group = Server.show(Group, group.id)
    users = group.users ++ [user]
    group = %{group | users: users}

    {:ok, Server.update(Group, group.id, group)}
  end

  def remove_user(%Endpoint{token: nil}, _, _), do: Endpoint.invalid_endpoint
  def remove_user(%Endpoint{token: _}, group, user) do
    user = Server.show_by_key(User, :email_address, user.email_address)
    group = Server.show(Group, group.id)
    users = group.users -- [user]
    group = %{group | users: users}

    {:ok, Server.update(Group, group.id, group)}
  end
end
