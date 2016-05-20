defmodule CogApi.Resources.Command do
  @derive [Poison.Encoder]

  defstruct [
    :id,
    :documentation,
    :name,
    :bundle,
    rules: [],
  ]
end
