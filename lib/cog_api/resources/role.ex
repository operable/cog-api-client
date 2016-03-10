defmodule CogApi.Resources.Role do
  @derive [Poison.Encoder]

  defstruct [
    :id,
    :name,
  ]
end
