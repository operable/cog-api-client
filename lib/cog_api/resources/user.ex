defmodule CogApi.Resources.User do
  @derive [Poison.Encoder]

  alias CogApi.Resources.Group
  alias CogApi.Resources.ChatHandle

  defstruct [
    :id,
    :first_name,
    :last_name,
    :email_address,
    :username,
    :password,
    groups: [],
    chat_handles: [],
  ]

  def format do
    %__MODULE__{
      groups: [Group.format],
      chat_handles: [ChatHandle.format],
    }
  end

  def fake_key do
    :users
  end

  def associations do
    [
      groups: Group,
      # chat_handles: ChatHandle,
    ]
  end

  def permissions(user \\ %__MODULE__{}) do
    Enum.flat_map(user.groups, fn (group) ->
      Enum.flat_map(group.roles, &(&1.permissions))
    end)
  end
end
