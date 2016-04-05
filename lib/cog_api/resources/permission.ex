defmodule CogApi.Resources.Permission do
  @derive [Poison.Encoder]

  defstruct [
    :id,
    :name,
    :namespace,
  ]

  def fake_server_information do
    %{
      key: :permissions,
      associations: [
      ]
    }
  end
end
