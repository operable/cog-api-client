defmodule CogApi.Resources.ChatHandle do
  @derive [Poison.Encoder]

  defstruct [
    :id,
    :handle,
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
