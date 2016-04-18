defmodule CogApi.Fake.ResourceHelpers do
  import CogApi.TestHelpers
  alias CogApi.Fake.Client

  def find_or_create_user(endpoint, name) do
    params = %{
      email_address: name,
      username: name,
      password: "password",
    }
    Client.user_create(endpoint, params) |> get_value
  end
end
