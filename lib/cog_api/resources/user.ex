defmodule CogApi.Resources.User do
  @derive [Poison.Encoder]

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
      groups: [%CogApi.Resources.Group{}],
    }
  end

  def fake_server_information do
    %{
      key: :users,
      associations: [
      ]
    }
  end
end
