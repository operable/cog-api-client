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

  def permissions(user \\ %__MODULE__{}) do
    Enum.flat_map(user.groups, fn (group) ->
      Enum.flat_map(group.roles, &(&1.permissions))
    end)
  end
end
