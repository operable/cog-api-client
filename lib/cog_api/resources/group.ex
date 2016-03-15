defmodule CogApi.Resources.Group do
  @derive [Poison.Encoder]

  defstruct [
    :id,
    :name,
  ]
end
