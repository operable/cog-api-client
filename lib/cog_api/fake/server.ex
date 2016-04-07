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

  def index(module) do
    find_all(module)
    |> Enum.map(fn resource -> expand_assocations(resource, module.associations) end)
  end

  defp find_all(module) do
    Agent.get(__MODULE__, fn server ->
      Map.fetch!(server, module.fake_key)
    end)
  end

  def show(module, id, stop_recursion \\ nil) do
    resource = Agent.get(__MODULE__, fn server ->
      find_by_id(server, module.fake_key, id)
    end)

    if resource do
      expand_assocations(resource, module.associations, stop_recursion)
    end
  end

  def raw_show(module, id) do
    Agent.get(__MODULE__, fn server ->
      find_by_id(server, module.fake_key, id)
    end)
  end

  def show_by_key(module, key, value) do
    resource = Agent.get(__MODULE__, fn server ->
      find_by_key(server, module.fake_key, key, value)
    end)

    if resource do
      expand_assocations(resource, module.associations)
    end
  end

  def create(module, new_resource) do
    Agent.get_and_update(__MODULE__, fn server ->
      Map.get_and_update(server, module.fake_key, fn list ->
        reduced_resource = reduce_associations(new_resource, module.associations)
        {reduced_resource, list ++ [reduced_resource]}
      end)
    end)

    new_resource
  end

  def update(module, id, new_resource) do
    resource = Agent.get_and_update(__MODULE__, fn server ->
      Map.get_and_update(server, module.fake_key, fn list ->
        update_by_id(list, id, reduce_associations(new_resource, module.associations))
      end)
    end)

    expand_assocations(resource, module.associations)
  end

  def delete(module, id) do
    Agent.update(__MODULE__, fn server ->
      Map.update!(server, module.fake_key, fn list ->
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

  defp expand_assocations(resource, associations, stop_recursion \\ nil)
  defp expand_assocations(resource, _, :stop_recursion), do: resource
  defp expand_assocations(resource, associations, _) do
    Enum.reduce(associations, resource, fn {relationship_name, server_key}, resource ->
      items = resource
      |> Map.get(relationship_name)
      |> Enum.map(fn id -> show(server_key, id, :stop_recursion) end)

      Map.put resource, relationship_name, items
    end)
  end

  defp reduce_associations(resource, associations) do
    Enum.reduce(associations, resource, fn {relationship_name, _}, resource ->
      ids = Map.get(resource, relationship_name)
      |> map_by_id
      Map.put(resource, relationship_name, ids)
    end)
  end

  defp map_by_id(nil) do
    []
  end

  defp map_by_id(list) do
    list |> Enum.map(&(&1.id))
  end
end
