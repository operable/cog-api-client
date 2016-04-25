defmodule CogApi.Decoders.Bundle do
  defstruct [
    :enabled,
    :id,
    :inserted_at,
    :name,
    :updated_at,
    :version,
    commands: [],
    relay_groups: [],
  ]

  def format do
    %__MODULE__{
      commands: [%CogApi.Resources.Command{}],
      relay_groups: [%CogApi.Resources.RelayGroup{}],
    }
  end

  def to_resource(decoder) do
    %CogApi.Resources.Bundle{
      commands: decoder.commands,
      enabled: decoder.enabled,
      id: decoder.id,
      inserted_at: decoder.inserted_at,
      modifiable: modifiable?(decoder.name),
      name: decoder.name,
      relay_groups: decoder.relay_groups,
      updated_at: decoder.updated_at,
      version: decoder.version,
    }
  end

  def modifiable?(name) do
    name != "operable"
  end
end
