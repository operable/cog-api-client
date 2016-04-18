defmodule CogApi.HTTP.ResourceHelpers do
  import CogApi.TestHelpers
  alias CogApi.HTTP.Client

  def find_or_create_user(endpoint, name) do
    params = %{
      email_address: name,
      username: name,
      password: "password",
    }
    case Client.user_create(endpoint, params) do
      {:ok, user} -> user
      {:error, _} ->
        Client.user_index(endpoint)
        |> get_value
        |> Enum.find(&(&1.email_address == name))
    end
  end
end
