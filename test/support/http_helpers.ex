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
end
