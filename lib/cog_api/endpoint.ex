defmodule CogApi.Endpoint do
  defstruct [
    proto: "http",
    host: "localhost",
    port: 4000,
    version: 1,
    token: nil,
    email: nil,
    username: nil,
    password: nil
  ]

  def invalid_endpoint do
    {:error, "You must provide an authenticated endpoint"}
  end
end
