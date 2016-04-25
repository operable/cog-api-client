defmodule CogApi.Resources.Bundle do
  @derive [Poison.Encoder]

  alias CogApi.Resources.RelayGroup

  defstruct [
    :enabled,
    :id,
    :inserted_at,
    :name,
    :updated_at,
    :version,
    :modifiable,
    commands: [],
    permissions: [],
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
      permissions: [%CogApi.Resources.Permission{}],
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
