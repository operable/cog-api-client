defmodule CogApi.Resources.Relay do
  @derive [Poison.Encoder]

  defstruct [
    :id,
    :name,
    :updated_at,
    :inserted_at,
    :enabled,
    groups: [],
  ]

  def format do
    %__MODULE__{
      groups: [%CogApi.Resources.RelayGroup{}],
    }
  end
end
