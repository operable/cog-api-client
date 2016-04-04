defmodule CogApi.Resources.RelayGroup do
  @derive [Poison.Encoder]

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
      relays: [%CogApi.Resources.Relay{}],
    }
  end
end
