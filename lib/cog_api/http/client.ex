defmodule CogApi.HTTP.Client do
  @behaviour CogApi.Client

  alias CogApi.Endpoint
  alias CogApi.HTTP.Groups
  alias CogApi.HTTP.Roles
  alias CogApi.HTTP.Permissions
  alias CogApi.HTTP.Bundles
  alias CogApi.HTTP.Users

  def authenticate(%Endpoint{token: nil}=endpoint) do
    CogApi.HTTP.Authentication.get_and_merge_token(endpoint)
  end

  def bundle_index(%Endpoint{}=endpoint) do
    Bundles.index(endpoint)
  end

  def bundle_update(%Endpoint{}=endpoint, bundle_id, params) do
    Bundles.update(endpoint, bundle_id, params)
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

  def group_add_user(%Endpoint{}=endpoint, group, user) do
    Groups.add_user(endpoint, group, user)
  end

  def group_remove_user(%Endpoint{}=endpoint, group, user) do
    Groups.remove_user(endpoint, group, user)
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

  def role_grant(%Endpoint{}=endpoint, role, group) do
    Roles.grant(endpoint, role, group)
  end

  def role_revoke(%Endpoint{}=endpoint, role, group) do
    Roles.revoke(endpoint, role, group)
  end

  def user_index(%Endpoint{}=endpoint) do
    Users.index(endpoint)
  end

  def user_show(%Endpoint{}=endpoint, user_id) do
    Users.show(endpoint, user_id)
  end

  def user_create(%Endpoint{}=endpoint, params) do
    Users.create(endpoint, params)
  end

  def user_update(%Endpoint{}=endpoint, user_id, params) do
    Users.update(endpoint, user_id, params)
  end

  def user_delete(%Endpoint{}=endpoint, user_id) do
    Users.delete(endpoint, user_id)
  end
end
