defmodule CogApi.Resources.Namespace do
  @derive [Poison.Encoder]

  defstruct [
    :id,
    :name,
  ]
end
