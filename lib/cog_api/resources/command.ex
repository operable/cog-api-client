defmodule CogApi.Resources.Command do
  @derive [Poison.Encoder]

  defstruct [
    :id,
    :documentation,
    :enforcing,
    :name,
    rules: [],
  ]
end
