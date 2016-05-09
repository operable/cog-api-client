defmodule CogApi.Decoders.User do
  import CogApi.Decoders.Helpers

  defstruct [
    :id,
    :first_name,
    :last_name,
    :email_address,
    :username,
    groups: [],
    chat_handles: [],
  ]

  def format do
    %__MODULE__{
      groups: [CogApi.Resources.Group.format],
      chat_handles: [CogApi.Decoders.ChatHandle.format],
    }
  end

  def to_resource(decoder) do
    %CogApi.Resources.User{
      id: decoder.id,
      first_name: decoder.first_name,
      last_name: decoder.last_name,
      email_address: decoder.email_address,
      username: decoder.username,
      groups: decoder.groups,
      chat_handles: decode_many(decoder.chat_handles, CogApi.Decoders.ChatHandle),
    }
  end
end
