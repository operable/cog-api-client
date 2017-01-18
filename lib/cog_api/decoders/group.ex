defmodule CogApi.Decoders.Group do
  import CogApi.Decoders.Helpers

  defstruct [
    :id,
    :name,
    :roles,
    :users
  ]

  def format do
    %__MODULE__{
      roles: [%CogApi.Resources.Role{}],
      users: [%CogApi.Resources.User{}]
    }
  end

  def to_resource(decoder) do
    %CogApi.Resources.Group{
      id: decoder.id,
      modifiable: modifiable?(decoder.name),
      name: decoder.name,
      users: decoder.users,
      roles: decode_many(decoder.roles, CogApi.Decoders.Role),
    }
  end

  def modifiable?(name) do
    name != "cog-admin"
  end
end
