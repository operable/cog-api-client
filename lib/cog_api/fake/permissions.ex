defmodule CogApi.Fake.Permissions do
  import CogApi.Fake.Random

  alias CogApi.Endpoint
  alias CogApi.Fake.Server
  alias CogApi.Resources.Permission
  alias CogApi.Resources.Namespace

  def permission_index(%Endpoint{token: nil}),  do: Endpoint.invalid_endpoint
  def permission_index(%Endpoint{}) do
    {:ok, Server.index(:permissions)}
  end

  def permission_create(%Endpoint{token: nil}, %{name: _}), do: Endpoint.invalid_endpoint
  def permission_create(%Endpoint{token: _}, name) do
    [namespace, name] = build_namespaced_name(name)

    new_permission = %Permission{
      id: random_string(8),
      name: name,
      namespace: %Namespace{id: random_string(8), name: namespace},
    }

    {:ok, Server.create(:permissions, new_permission)}
  end

  defp build_namespaced_name(name) do
    case String.split(name, ":") do
      [namespace, name] -> [namespace, name]
      [name] -> ["site", name]
    end
  end
end
