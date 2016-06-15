defmodule CogApi.Resources.Command do
  @derive [Poison.Encoder]

  alias CogApi.Resources.CommandOpt
  alias CogApi.Resources.Rule

  defstruct [
    :id,
    :description,
    :documentation,
    :name,
    :bundle,
    options: [%CommandOpt{}],
    rules: [%Rule{}],
  ]
end
