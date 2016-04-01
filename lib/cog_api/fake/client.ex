defmodule CogApi.Fake.Client do
  @behaviour CogApi.Client

  alias CogApi.Endpoint

  alias CogApi.Fake.Bundles
  alias CogApi.Fake.Groups
  alias CogApi.Fake.Permissions
  alias CogApi.Fake.Relays
  alias CogApi.Fake.RelayGroups
  alias CogApi.Fake.Roles
  alias CogApi.Fake.Rules
  alias CogApi.Fake.Users

  def authenticate(%Endpoint{token: nil}=endpoint) do
    CogApi.Fake.Authentication.get_and_merge_token(endpoint)
  end

  def bundle_index(%Endpoint{}=endpoint) do
    Bundles.index(endpoint)
  end

  def bundle_create(%Endpoint{}=endpoint, bundle) do
    Bundles.create(endpoint, bundle)
  end

  def bundle_show(%Endpoint{}=endpoint, bundle_id) do
    Bundles.show(endpoint, bundle_id)
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

  def group_create(%Endpoint{}=endpoint, params) do
    Groups.create(endpoint, params)
  end

  def group_delete(%Endpoint{}=endpoint, role_id) do
    Groups.delete(endpoint, role_id)
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

  def relay_index(%Endpoint{}=endpoint) do
    Relays.index(endpoint)
  end

  def relay_show(relay_id, %Endpoint{}=endpoint) do
    Relays.show(relay_id, endpoint)
  end

  def relay_create(params, %Endpoint{}=endpoint) do
    Relays.create(params, endpoint)
  end

  def relay_update(relay_id, params, %Endpoint{}=endpoint) do
    Relays.update(relay_id, params, endpoint)
  end

  def relay_delete(relay_id, %Endpoint{}=endpoint) do
    Relays.delete(relay_id, endpoint)
  end

  def relay_group_index(%Endpoint{}=endpoint) do
    RelayGroups.index(endpoint)
  end

  def relay_group_show(relay_group_id, %Endpoint{}=endpoint) do
    RelayGroups.show(relay_group_id, endpoint)
  end

  def relay_group_create(params, %Endpoint{}=endpoint) do
    RelayGroups.create(params, endpoint)
  end

  def relay_group_update(relay_group_id, params, %Endpoint{}=endpoint) do
    RelayGroups.update(relay_group_id, params, endpoint)
  end

  def relay_group_delete(relay_group_id, %Endpoint{}=endpoint) do
    RelayGroups.delete(relay_group_id, endpoint)
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

  def role_update(endpoint, role_id, params) do
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

  def rule_index(command, %Endpoint{}=endpoint) do
    Rules.index(command, endpoint)
  end

  def rule_create(rule_text, %Endpoint{}=endpoint) do
    Rules.create(rule_text, endpoint)
  end

  def rule_delete(rule_id, %Endpoint{}=endpoint) do
    Rules.delete(rule_id, endpoint)
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
