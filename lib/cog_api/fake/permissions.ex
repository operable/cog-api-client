defmodule CogApi.Fake.Permissions do
  import CogApi.Fake.Random

  alias CogApi.Endpoint
  alias CogApi.Fake.Server
  alias CogApi.Resources.Permission
  alias CogApi.Resources.Namespace

  def index(%Endpoint{token: nil}),  do: Endpoint.invalid_endpoint
  def index(%Endpoint{}) do
    {:ok, Server.index(Permission)}
  end

  def create(%Endpoint{token: nil}, %{name: _}), do: Endpoint.invalid_endpoint
  def create(%Endpoint{token: _}, name) do
    [namespace, name] = build_namespaced_name(name)

    new_permission = %Permission{
      id: random_string(8),
      name: name,
      namespace: %Namespace{id: random_string(8), name: namespace},
    }

    {:ok, Server.create(Permission, new_permission)}
  end

  defp build_namespaced_name(name) do
    case String.split(name, ":") do
      [namespace, name] -> [namespace, name]
      [name] -> ["site", name]
    end
  end
end
