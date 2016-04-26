defmodule CogApi.Decoders.RelayGroup do
  import CogApi.Decoders.Helpers

  alias CogApi.Resources.Relay
  alias CogApi.Resources.Bundle

  defstruct [
    :id,
    :inserted_at,
    :name,
    :updated_at,
    bundles: [],
    relays: [],
  ]

  def format do
    %__MODULE__{
      bundles: [%Bundle{}],
      relays: [%Relay{}],
    }
  end

  def to_resource(decoder) do
    %CogApi.Resources.RelayGroup{
      bundles: decode_many(decoder.bundles, CogApi.Decoders.Bundle),
      id: decoder.id,
      inserted_at: decoder.inserted_at,
      name: decoder.name,
      relays: decoder.relays,
      updated_at: decoder.updated_at,
    }
  end
end
