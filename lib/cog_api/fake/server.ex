defmodule CogApi.Fake.Server do
  defstruct [
    bundles: [],
    groups: [],
    permissions: [],
    relays: [],
    relay_groups: [],
    roles: [],
    rules: [],
    users: [],
  ]

  def start_link do
    Agent.start_link(fn -> %__MODULE__{} end, name: __MODULE__)
  end

  def reset do
    Agent.update(__MODULE__, fn _ ->
      %__MODULE__{}
    end)
  end

  def index(resource_name) do
    Agent.get(__MODULE__, fn server ->
      Map.fetch!(server, resource_name)
    end)
  end

  def show(resource_name, id) do
    Agent.get(__MODULE__, fn server ->
      find_by_id(server, resource_name, id)
    end)
  end

  def show_by_key(resource_name, key, value) do
    Agent.get(__MODULE__, fn server ->
      find_by_key(server, resource_name, key, value)
    end)
  end

  def create(resource_name, new_resource) do
    Agent.get_and_update(__MODULE__, fn server ->
      Map.get_and_update(server, resource_name, fn list ->
        {new_resource, list ++ [new_resource]}
      end)
    end)
  end

  def update(resource_name, id, new_resource) do
    Agent.get_and_update(__MODULE__, fn server ->
      Map.get_and_update(server, resource_name, fn list ->
        update_by_id(list, id, new_resource)
      end)
    end)
  end

  def delete(resource_name, id) do
    Agent.update(__MODULE__, fn server ->
      Map.update!(server, resource_name, fn list ->
        delete_by_id(list, id)
      end)
    end)
  end

  defp update_by_id(list, id, params) do
    index = Enum.find_index(list, fn resource -> resource.id == id end)
    old_resource = Enum.at(list, index)
    new_resource = Map.merge(old_resource, params)
    new_list = List.replace_at(list, index, new_resource)
    {new_resource, new_list}
  end

  defp delete_by_id(list, id) do
    index = Enum.find_index(list, fn resource -> resource.id == id end)
    List.delete_at(list, index)
  end

  defp find_by_id(server, resource_name, id) do
    find_by_key(server, resource_name, :id, id)
  end

  defp find_by_key(server, resource_name, key, value) do
    Map.fetch!(server, resource_name)
    |> Enum.find(fn resource -> Map.get(resource, key) == value end)
  end
end
