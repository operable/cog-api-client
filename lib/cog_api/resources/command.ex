defmodule CogApi.Resources.Command do
  @derive [Poison.Encoder]

  alias CogApi.Resources.Rule

  defstruct [
    :id,
    :description,
    :documentation,
    :name,
    :bundle,
    rules: [%Rule{}],
  ]
end
