defmodule CogApi.Resources.Role do
  @derive [Poison.Encoder]

  alias CogApi.Resources.Group
  alias CogApi.Resources.Permission

  defstruct [
    :id,
    :name,
    groups: [],
    permissions: [],
  ]

  def format do
    %__MODULE__{
      groups: [%Group{}],
      permissions: [%Permission{}],
    }
  end

  def fake_key do
    :roles
  end

  def associations do
    [
      groups: Group,
      permissions: Permission,
    ]
  end
end
