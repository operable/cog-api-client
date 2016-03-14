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

  def role_index do
    Agent.get(__MODULE__, fn server ->
      server.roles
    end)
  end

  def role_show(id) do
    Agent.get(__MODULE__, fn server ->
      find_by_id(server.roles, id)
    end)
  end

  def role_create(role) do
    Agent.get_and_update(__MODULE__, fn server ->
      server = %{ server | roles: server.roles ++ [role] }
      {role, server}
    end)
  end

  defp find_by_id(list, id) do
    Enum.find(list, fn resource -> resource.id == id end)
  end
end
