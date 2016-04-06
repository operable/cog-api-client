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

  def fake_server_information do
    %{
      key: :roles,
      associations: [
        permissions: Permission.fake_server_information,
      ]
    }
  end
end
