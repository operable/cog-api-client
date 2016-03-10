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
end
