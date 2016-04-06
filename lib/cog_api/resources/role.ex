defmodule CogApi.Resources.Role do
  @derive [Poison.Encoder]

  alias CogApi.Resources.Permission

  defstruct [
    :id,
    :name,
    permissions: [],
  ]

  def format do
    %__MODULE__{
      permissions: [%Permission{}],
    }
  end

  def fake_key do
    :roles
  end

  def associations do
    [
      permissions: Permission,
    ]
  end
end
