defmodule CogHelper do
  alias CogApi.Endpoint

  def valid_endpoint do
    {:ok, endpoint} = %Endpoint{
      username: "admin",
      password: "password",
      host: "localhost",
      port: "4000",
    } |> CogApi.HTTPClient.authenticate

    endpoint
  end

  def present(string) do
    String.length(string) > 1
  end
end
