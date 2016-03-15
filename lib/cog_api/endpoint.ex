defmodule CogApi.Endpoint do
  defstruct [
    proto: "http",
    host: nil,
    port: nil,
    version: 1,
    token: nil,
    username: nil,
    password: nil
  ]

  def invalid_endpoint do
    {:error, "You must provide an authenticated endpoint"}
  end
end
