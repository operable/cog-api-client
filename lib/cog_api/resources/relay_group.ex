defmodule CogApi.Resources.RelayGroup do
  @derive [Poison.Encoder]

  alias CogApi.Resources.Relay
  alias CogApi.Resources.Bundle

  defstruct [
    :id,
    :name,
    :updated_at,
    :inserted_at,
    bundles: [],
    relays: [],
    bundles: [],
  ]

  def format do
    %__MODULE__{
      bundles: [%Bundle{}],
      relays: [%Relay{}],
    }
  end

  def fake_key do
    :relay_groups
  end

  def associations do
    [
      relays: Relay,
      bundles: Bundle,
    ]
  end
end
