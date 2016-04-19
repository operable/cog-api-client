defmodule CogApi.HTTP.Users do
  alias CogApi.HTTP.ApiResponse
  alias CogApi.HTTP.Base

  alias CogApi.Endpoint
  alias CogApi.Resources.User

  def index(%Endpoint{}=endpoint) do
    Base.get(endpoint, "users")
    |> ApiResponse.format(%{"users" => [User.format]})
  end

  def show(%Endpoint{}=endpoint, %{username: username}) do
    Base.get(endpoint, "users?username=#{username}")
    |> ApiResponse.format(%{"user" => User.format})
  end
  def show(%Endpoint{}=endpoint, id) do
    Base.get(endpoint, "users/#{id}")
    |> ApiResponse.format(%{"user" => User.format})
  end

  def create(%Endpoint{}=endpoint, params) do
    Base.post(endpoint, "users", %{user: params})
    |> ApiResponse.format(%{"user" => User.format})
  end

  def update(%Endpoint{}=endpoint, id, params) do
    Base.patch(endpoint, "users/#{id}", %{"user" => params})
    |> ApiResponse.format(%{"user" => User.format})
  end

  def delete(%Endpoint{}=endpoint, id) do
    Base.delete(endpoint, "users/#{id}")
    |> ApiResponse.format(%{"user" => User.format})
  end
end
