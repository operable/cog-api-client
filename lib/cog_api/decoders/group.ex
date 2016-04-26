defmodule CogApi.Decoders.Group do
  import CogApi.Decoders.Helpers

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
      roles: decode_many(decoder.members.roles, CogApi.Decoders.Role),
    }
  end

  def modifiable?(name) do
    name != "cog-admin"
  end
end
