defmodule CogApi.Decoders.Role do
  alias CogApi.Resources.Group
  alias CogApi.Resources.Permission

  defstruct [
    :id,
    :name,
    groups: [],
    permissions: [],
  ]

  def format do
    %__MODULE__{
      groups: [%Group{}],
      permissions: [%Permission{}],
    }
  end

  def to_resource(decoder) do
    %CogApi.Resources.Role{
      id: decoder.id,
      modifiable: modifiable?(decoder.name),
      name: decoder.name,
      groups: decoder.groups,
      permissions: decoder.permissions,
    }
  end

  def modifiable?(name) do
    name != "cog-admin"
  end
end
