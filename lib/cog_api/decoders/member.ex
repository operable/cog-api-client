defmodule CogApi.Decoders.Member do
  defstruct [
    users: [%CogApi.Resources.User{}]
  ]
end
