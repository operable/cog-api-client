defmodule CogApi.HTTP.Users do
  alias CogApi.HTTP.Base

  alias CogApi.Endpoint
  alias CogApi.Resources.User

  def index(%Endpoint{}=endpoint) do
    Base.get(endpoint, "users") |> Base.format_response("users", [%User{}])
  end

  def create(%Endpoint{}=endpoint, params) do
    Base.post(endpoint, "users", %{user: params})
    |> Base.format_response("user", %User{})
  end
end
