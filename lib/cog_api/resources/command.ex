defmodule CogApi.Resources.Command do
  @derive [Poison.Encoder]

  defstruct [
    :id,
    :name,
    :documentation,
  ]
end
