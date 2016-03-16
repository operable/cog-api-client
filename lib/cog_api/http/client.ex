defmodule CogApi.HTTP.Client do
  @behaviour CogApi.Client

  alias CogApi.Endpoint
  alias CogApi.HTTP.Groups
  alias CogApi.HTTP.Roles
  alias CogApi.HTTP.Permissions
  alias CogApi.HTTP.Bundles

  def authenticate(%Endpoint{token: nil}=endpoint) do
    CogApi.HTTP.Authentication.get_and_merge_token(endpoint)
  end

  def bundle_index(%Endpoint{}=endpoint) do
    Bundles.index(endpoint)
  end

  def group_index(%Endpoint{}=endpoint) do
    Groups.index(endpoint)
  end

  def group_show(%Endpoint{}=endpoint, group_id) do
    Groups.show(endpoint, group_id)
  end

  def group_create(%Endpoint{}=endpoint, name) do
    Groups.create(endpoint, name)
  end

  def permission_index(%Endpoint{}=endpoint) do
    Permissions.index(endpoint)
  end

  def permission_create(%Endpoint{}=endpoint, name) do
    Permissions.create(endpoint, name)
  end

  def role_index(endpoint) do
    Roles.index(endpoint)
  end

  def role_show(endpoint, id) do
    Roles.show(endpoint, id)
  end

  def role_create(endpoint, params) do
    Roles.create(endpoint, params)
  end

  def role_update(%Endpoint{}=endpoint, role_id, params) do
    Roles.update(endpoint, role_id, params)
  end

  def role_delete(%Endpoint{}=endpoint, role_id) do
    Roles.delete(endpoint, role_id)
  end
end
