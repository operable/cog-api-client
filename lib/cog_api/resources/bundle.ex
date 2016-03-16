defmodule CogApi.Resources.Bundle do
  @derive [Poison.Encoder]

  defstruct [
    :id,
    :name,
  ]
end
