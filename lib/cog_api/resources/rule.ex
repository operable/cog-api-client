defmodule CogApi.Resources.Rule do
  @derive [Poison.Encoder]

  defstruct [
    :id,
    :command,
    :rule,
  ]

  def fake_server_information do
    %{
      key: :rules,
      associations: [
      ]
    }
  end
end
