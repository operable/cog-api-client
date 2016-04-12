defmodule CogApi.Resources.Bundle do
  @derive [Poison.Encoder]

  alias CogApi.Resources.RelayGroup

  defstruct [
    :id,
    :enabled,
    :name,
    :inserted_at,
    :updated_at,
    :version,
    commands: [],
    relay_groups: [],
  ]

  def decode_status("enabled"), do: true
  def decode_status("disabled"), do: false

  def encode_status("true"), do: "enabled"
  def encode_status(true), do: "enabled"
  def encode_status(_), do: "disabled"

  def format do
    %__MODULE__{
      commands: [%CogApi.Resources.Command{}],
      relay_groups: [%RelayGroup{}],
    }
  end

  def fake_key do
    :bundles
  end

  def associations do
    [
      relay_groups: RelayGroup
    ]
  end
end
