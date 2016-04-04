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

  def to_group(group_decoder) do
    %CogApi.Resources.Group{
      id: group_decoder.id,
      name: group_decoder.name,
      users: group_decoder.members.users,
      roles: group_decoder.members.roles,
    }
  end
end
