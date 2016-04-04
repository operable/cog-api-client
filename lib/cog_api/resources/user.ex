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
end
