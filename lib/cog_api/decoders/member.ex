defmodule CogApi.Decoders.Member do
  defstruct [
    roles: [],
    users: [],
  ]

  def format do
    %__MODULE__{
      roles: [%CogApi.Resources.Role{}],
      users: [%CogApi.Resources.User{}],
    }
  end
end
