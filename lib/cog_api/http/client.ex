defmodule CogApi.HTTP.Client do
  @behaviour CogApi.Client

  alias CogApi.Endpoint
  alias CogApi.HTTP.Roles

  def authenticate(%Endpoint{token: nil}=endpoint) do
    CogApi.HTTP.Authentication.get_and_merge_token(endpoint)
  end

  def role_index(endpoint) do
    Roles.role_index(endpoint)
  end

  def role_show(endpoint, id) do
    Roles.role_show(endpoint, id)
  end

  def role_create(endpoint, params) do
    Roles.role_create(endpoint, params)
  end

  def role_update(%Endpoint{}=endpoint, role_id, params) do
    Roles.role_update(endpoint, role_id, params)
  end
end
