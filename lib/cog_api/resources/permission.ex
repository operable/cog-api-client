defmodule CogApi.Resources.Permission do
  @derive [Poison.Encoder]

  defstruct [
    :id,
    :name,
    namespace: %CogApi.Resources.Namespace{},
  ]
end
