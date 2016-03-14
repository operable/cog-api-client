defmodule CogApi.Fake.Server do
  defstruct [
    roles: []
  ]

  def start_link do
    Agent.start_link(fn -> %__MODULE__{} end, name: __MODULE__)
  end

  def reset do
    Agent.update(__MODULE__, fn _ ->
      %__MODULE__{}
    end)
  end

  def index(resource) do
    Agent.get(__MODULE__, fn server ->
      Map.fetch!(server, resource)
    end)
  end

  def show(resource, id) do
    Agent.get(__MODULE__, fn server ->
      find_by_id(server, resource, id)
    end)
  end

  def create(resource, new_resource) do
    Agent.get_and_update(__MODULE__, fn server ->
      Map.get_and_update(server, resource, fn list ->
        {new_resource, list ++ [new_resource]}
      end)
    end)
  end

  defp find_by_id(server, resource, id) do
    Map.fetch!(server, resource)
    |> Enum.find(fn resource -> resource.id == id end)
  end
end
