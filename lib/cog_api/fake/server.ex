defmodule CogApi.Fake.Server do
  defstruct [
    roles: []
  ]

  def start_link do
    Agent.start_link(fn -> %__MODULE__{} end, name: __MODULE__)
  end

  def role_create(role) do
    Agent.get_and_update(__MODULE__, fn server ->
      server = %{ server | roles: server.roles ++ [role] }
      {role, server}
    end)
  end

  def role_index do
    Agent.get(__MODULE__, fn server ->
      server.roles
    end)
  end
end
