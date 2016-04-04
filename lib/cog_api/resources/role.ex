defmodule CogApi.Resources.Role do
  @derive [Poison.Encoder]

  defstruct [
    :id,
    :name,
    permissions: [],
  ]

  def format do
    %__MODULE__{
      permissions: [%CogApi.Resources.Permission{}],
    }
  end
end
