defmodule CogApi.Resources.Rule do
  @derive [Poison.Encoder]

  defstruct [
    :id,
    :command,
    :rule,
  ]
end
