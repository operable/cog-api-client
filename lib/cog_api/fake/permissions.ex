defmodule CogApi.Fake.Permissions do
  import CogApi.Fake.Random
  import CogApi.Fake.Helpers

  alias CogApi.Endpoint
  alias CogApi.Fake.Server
  alias CogApi.Resources.Permission

  use CogApi.Fake.InvalidCrudResponses

  def index(%Endpoint{}) do
    {:ok, Server.index(Permission)}
  end

  def create(%Endpoint{token: _}, name) do
    catch_errors %Permission{}, %{name: name}, fn ->
      [namespace, name] = build_namespaced_name(name)

      new_permission = %Permission{
        id: random_string(8),
        name: name,
        namespace: namespace,
      }

      {:ok, Server.create(Permission, new_permission)}
    end
  end

  def delete(%Endpoint{token: _}, id) do
    if permission = Server.show!(Permission, id) do
      if permission.namespace == "site" do
        Server.delete(Permission, id)
        :ok
      else
        return_error("Deleting permissions outside of the site namespace is forbidden.")
      end
    else
      return_error("The permission could not be deleted")
    end
  end

  defp build_namespaced_name(name) do
    case String.split(name, ":") do
      [namespace, name] -> [namespace, name]
      [name] -> ["site", name]
    end
  end
end
