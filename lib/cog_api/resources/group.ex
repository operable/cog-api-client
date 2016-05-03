defmodule CogApi.Resources.Group do

  @derive [Poison.Encoder]

  defstruct [
    :id,
    :name,
    :modifiable,
    roles: [],
    users: [],
  ]

  def format do
    %__MODULE__{
      roles: [CogApi.Resources.Role.format],
      users: [%CogApi.Resources.User{}],
    }
  end

  def fake_key do
    :groups
  end

  def associations do
    [
      users: CogApi.Resources.User,
    ]
  end
end
