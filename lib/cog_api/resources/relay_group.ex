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
end
