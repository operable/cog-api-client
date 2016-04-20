defmodule CogApi.Decoders.ChatHandle do
  defstruct [
    :id,
    :user_id,
    :handle,
    :chat_provider,
  ]

  def format do
    %__MODULE__{
      chat_provider: CogApi.Decoders.ChatProvider.format,
    }
  end

  def to_resource(decoder) do
    %CogApi.Resources.ChatHandle{
      id: decoder.id,
      handle: decoder.handle,
      chat_provider: decoder.chat_provider.name,
    }
  end
end
