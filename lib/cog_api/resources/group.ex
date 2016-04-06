defmodule CogApi.Resources.Group do
  @derive [Poison.Encoder]

  defstruct [
    :id,
    :name,
    roles: [],
    users: [],
  ]

  def format do
    %__MODULE__{
      roles: [%CogApi.Resources.Role{}],
      users: [%CogApi.Resources.User{}],
    }
  end

  def fake_key do
    :groups
  end

  def associations do
    [
    ]
  end
end
