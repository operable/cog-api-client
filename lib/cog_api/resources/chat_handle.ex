defmodule CogApi.Resources.ChatHandle do
  @derive [Poison.Encoder]

  defstruct [
    :id,
    :user_id,
    :handle,
    :chat_provider,
  ]

  def format do
    %__MODULE__{
    }
  end

  def fake_key do
    :chat_handles
  end

  def associations do
    [
    ]
  end
end
