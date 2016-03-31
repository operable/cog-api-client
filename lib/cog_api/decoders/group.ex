defmodule CogApi.Decoders.Group do
  defstruct [
    :id,
    :name,
    members: %CogApi.Decoders.Member{}
  ]

  def to_group(group_decoder) do
    %CogApi.Resources.Group{
      id: group_decoder.id,
      name: group_decoder.name,
      users: group_decoder.members.users,
    }
  end
end
