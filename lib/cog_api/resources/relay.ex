defmodule CogApi.Resources.Relay do
  @derive [Poison.Encoder]

  defstruct [
    :id,
    :name,
    :updated_at,
    :inserted_at,
  ]
end
