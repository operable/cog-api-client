defmodule CogApi.Resources.Command do
  @derive [Poison.Encoder]

  defstruct [
    :id,
    :description,
    :documentation,
    :name,
    :bundle,
    rules: [],
  ]
end
