defmodule CogApi.Fake.Client do
  alias CogApi.Endpoint
  alias CogApi.Fake.Roles

  def authenticate(%Endpoint{token: nil}=endpoint) do
    CogApi.Fake.Authentication.get_and_merge_token(endpoint)
  end

  def role_index(endpoint) do
    Roles.role_index(endpoint)
  end
end
