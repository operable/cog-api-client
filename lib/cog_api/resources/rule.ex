defmodule CogApi.Resources.Rule do
  @derive [Poison.Encoder]

  defstruct [
    :id,
    :command,
    :rule,
  ]

  def fake_key do
    :rules
  end

  def associations do
    []
  end
end
