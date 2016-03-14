defmodule CogApi.Fake.Client do
  @behaviour CogApi.Client

  alias CogApi.Endpoint
  alias CogApi.Fake.Roles

  def authenticate(%Endpoint{token: nil}=endpoint) do
    CogApi.Fake.Authentication.get_and_merge_token(endpoint)
  end

  def role_index(endpoint) do
    Roles.role_index(endpoint)
  end

  def role_create(endpoint, params) do
    Roles.role_create(endpoint, params)
  end
end
