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
end
