defmodule CogApi.Resources.RelayGroup do
  @derive [Poison.Encoder]
  alias CogApi.Resources.Relay

  defstruct [
    :id,
    :name,
    :updated_at,
    :inserted_at,
    bundles: [],
    relays: [],
  ]

  def format do
    %__MODULE__{
      bundles: [%CogApi.Resources.Bundle{}],
      relays: [%Relay{}],
    }
  end

  def fake_key do
    :relay_groups
  end

  def associations do
    [
      relays: Relay,
    ]
  end
end
