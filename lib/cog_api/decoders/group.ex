defmodule CogApi.Decoders.Group do
  defstruct [
    :id,
    :name,
    :members,
  ]

  def format do
    %__MODULE__{
      members: CogApi.Decoders.Member.format,
    }
  end

  def to_resource(decoder) do
    %CogApi.Resources.Group{
      id: decoder.id,
      modifiable: modifiable?(decoder.name),
      name: decoder.name,
      users: decoder.members.users,
      roles: decoder.members.roles,
    }
  end

  def modifiable?(name) do
    name != "cog-admin"
  end
end
