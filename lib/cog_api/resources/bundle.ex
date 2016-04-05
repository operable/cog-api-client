defmodule CogApi.Resources.Bundle do
  @derive [Poison.Encoder]

  defstruct [
    :id,
    :enabled,
    :name,
    :inserted_at,
    :updated_at,
    commands: [],
  ]

  def decode_status("enabled"), do: true
  def decode_status("disabled"), do: false

  def encode_status("true"), do: "enabled"
  def encode_status(true), do: "enabled"
  def encode_status(_), do: "disabled"

  def format do
    %__MODULE__{
      commands: [%CogApi.Resources.Command{}],
    }
  end

  def fake_server_information do
    %{
      key: :bundles,
      associations: [
      ]
    }
  end
end
