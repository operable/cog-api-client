defmodule CogApi.Test.HTTPHelpers do
  import CogApi.TestHelpers

  alias CogApi.Endpoint

  def valid_endpoint do
    {:ok, endpoint} = %Endpoint{
      username: "admin",
      password: "password",
      host: "localhost",
      port: "4000"
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

  def trigger_params(test_name) do
    %{name: "echo_#{test_name}",
      pipeline: "echo '#{test_name}' > chat://#general",
      as_user: "somebody_else",
      timeout_sec: 42,
      description: "Echoes some data, probably '#{test_name}' :P"}
  end

  def get_bundle(endpoint, bundle_name) do
    endpoint
    |> CogApi.HTTP.Client.bundle_index
    |> get_value
    |> Enum.find(fn(bundle) -> bundle.name == bundle_name end)
  end
end
