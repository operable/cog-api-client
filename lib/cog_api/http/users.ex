defmodule CogApi.HTTP.Users do
  alias CogApi.HTTP.Base

  alias CogApi.Endpoint
  alias CogApi.Resources.User

  def index(%Endpoint{}=endpoint) do
    Base.get(endpoint, "users") |> Base.format_response("users", [%User{}])
  end

  def show(%Endpoint{}=endpoint, id) do
    Base.get(endpoint, "users/#{id}")
    |> Base.format_response("user", %User{})
  end

  def create(%Endpoint{}=endpoint, params) do
    Base.post(endpoint, "users", %{user: params})
    |> Base.format_response("user", %User{})
  end

  def update(%Endpoint{}=endpoint, id, params) do
    Base.patch(endpoint, "users/#{id}", %{"user" => params})
    |> Base.format_response("user", %User{})
  end

  def delete(%Endpoint{}=endpoint, id) do
    Base.delete(endpoint, "users/#{id}")
    |> Base.format_response("user", %User{})
  end
end
