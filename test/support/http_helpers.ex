defmodule CogApi.Test.HTTPHelpers do
  alias CogApi.Endpoint

  def valid_endpoint do
    {:ok, endpoint} = %Endpoint{
      username: "admin",
      password: "password",
      host: "localhost",
      port: "4000",
    } |> CogApi.HTTP.Client.authenticate

    endpoint
  end

  def get_valid_endpoint(user, password) do
    {:ok, endpoint} = %Endpoint{
      username: user.username,
      password: password,
      host: "localhost",
      port: "4000",
    } |> CogApi.HTTP.Client.authenticate

    endpoint
  end

  def user_params(test_name) do
    %{
      first_name: "Leo",
      last_name: "McGary",
      email_address: "cos#{test_name}@example.com",
      username: "chief_of_staff#{test_name}",
      password: "supersecret",
    }
  end
end
