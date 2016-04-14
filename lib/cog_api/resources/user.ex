defmodule CogApi.Resources.User do
  @derive [Poison.Encoder]

  alias CogApi.Resources.Group

  defstruct [
    :id,
    :first_name,
    :last_name,
    :email_address,
    :username,
    groups: [],
  ]

  def format do
    %__MODULE__{
      groups: [Group.format],
    }
  end

  def fake_key do
    :users
  end

  def associations do
    [
      groups: Group
    ]
  end
end
