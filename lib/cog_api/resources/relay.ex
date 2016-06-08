defmodule CogApi.Resources.Relay do
  @derive [Poison.Encoder]

  defstruct [
    :id,
    :name,
    :updated_at,
    :inserted_at,
    :description,
    :token,
    enabled: false,
    groups: [],
  ]

  def format do
    %__MODULE__{
      groups: [%CogApi.Resources.RelayGroup{}],
    }
  end

  def fake_key do
    :relays
  end

  def associations do
    []
  end
end
