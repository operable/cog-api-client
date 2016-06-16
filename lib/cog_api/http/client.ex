defmodule CogApi.HTTP.Client do
  @behaviour CogApi.Client

  alias CogApi.Endpoint

  alias CogApi.HTTP.Bundles
  alias CogApi.HTTP.ChatHandles
  alias CogApi.HTTP.Groups
  alias CogApi.HTTP.Permissions
  alias CogApi.HTTP.Relays
  alias CogApi.HTTP.RelayGroups
  alias CogApi.HTTP.Roles
  alias CogApi.HTTP.Rules
  alias CogApi.HTTP.Triggers
  alias CogApi.HTTP.Users

  def authenticate(%Endpoint{token: nil}=endpoint) do
    CogApi.HTTP.Authentication.get_and_merge_token(endpoint)
  end

  def bundle_index(%Endpoint{}=endpoint) do
    Bundles.index(endpoint)
  end

  def bundle_version_index(%Endpoint{}=endpoint, bundle_id) do
    Bundles.version_index(endpoint, bundle_id)
  end

  def bundle_version_index_by_name(%Endpoint{}=endpoint, bundle_name) do
    Bundles.version_index_by_name(endpoint, bundle_name)
  end

  def bundle_version_show(%Endpoint{}=endpoint, bundle_id, bundle_version_id) do
    Bundles.version_show(endpoint, bundle_id, bundle_version_id)
  end

  def bundle_version_show_by_name(%Endpoint{}=endpoint, bundle_name, bundle_version) do
    Bundles.version_show_by_name(endpoint, bundle_name, bundle_version)
  end

  def bundle_show(%Endpoint{}=endpoint, bundle_id) do
    Bundles.show(endpoint, bundle_id)
  end

  def bundle_show_by_name(%Endpoint{}=endpoint, bundle_name) do
    Bundles.show_by_name(endpoint, bundle_name)
  end

  def bundle_uninstall(%Endpoint{}=endpoint, bundle_id) do
    Bundles.uninstall(endpoint, bundle_id)
  end

  def bundle_uninstall_by_name(%Endpoint{}=endpoint, bundle_name) do
    Bundles.uninstall_by_name(endpoint, bundle_name)
  end

  def bundle_uninstall_version(%Endpoint{}=endpoint, bundle_id, bundle_version_id) do
    Bundles.uninstall_version(endpoint, bundle_id, bundle_version_id)
  end

  def bundle_uninstall_version_by_name(%Endpoint{}=endpoint, bundle_name, bundle_version) do
    Bundles.uninstall_version_by_name(endpoint, bundle_name, bundle_version)
  end

  def bundle_install(%Endpoint{}=endpoint, params) do
    Bundles.install(endpoint, params)
  end

  def bundle_enable_version(%Endpoint{}=endpoint, bundle_id, bundle_version_id) do
    Bundles.enable_version(endpoint, bundle_id, bundle_version_id)
  end

  def bundle_enable_version_by_name(%Endpoint{}=endpoint, bundle_name, bundle_version) do
    Bundles.enable_version_by_name(endpoint, bundle_name, bundle_version)
  end

  def bundle_enabled_version(%Endpoint{}=endpoint, bundle_id) do
    Bundles.enabled_version(endpoint, bundle_id)
  end

  def bundle_enabled_version_by_name(%Endpoint{}=endpoint, bundle_name) do
    Bundles.enabled_version_by_name(endpoint, bundle_name)
  end

  def bundle_disable_version(%Endpoint{}=endpoint, bundle_id, bundle_version_id) do
    Bundles.disable_version(endpoint, bundle_id, bundle_version_id)
  end

  def bundle_disable_version_by_name(%Endpoint{}=endpoint, bundle_name, bundle_version) do
    Bundles.disable_version_by_name(endpoint, bundle_name, bundle_version)
  end

  def chat_handle_upsert(%Endpoint{}=endpoint, user_id, params) do
    ChatHandles.upsert(endpoint, user_id, params)
  end

  def chat_handle_delete(%Endpoint{}=endpoint, chat_handle_id) do
    ChatHandles.delete(endpoint, chat_handle_id)
  end

  def group_index(%Endpoint{}=endpoint) do
    Groups.index(endpoint)
  end

  def group_show(%Endpoint{}=endpoint, group_id) do
    Groups.show(endpoint, group_id)
  end

  def group_find(%Endpoint{}=endpoint, params) do
    Groups.find(endpoint, params)
  end

  def group_create(%Endpoint{}=endpoint, name) do
    Groups.create(endpoint, name)
  end

  def group_update(%Endpoint{}=endpoint, group_id, params) do
    Groups.update(endpoint, group_id, params)
  end

  def group_delete(%Endpoint{}=endpoint, group_id) do
    Groups.delete(endpoint, group_id)
  end

  def group_add_role(%Endpoint{}=endpoint, group, role) do
    Groups.add_role(endpoint, group, role)
  end

  def group_remove_role(%Endpoint{}=endpoint, group, role) do
    Groups.remove_role(endpoint, group, role)
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

  def permission_delete(%Endpoint{}=endpoint, permission_id) do
    Permissions.delete(endpoint, permission_id)
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

  def relay_group_add_relays_by_name(relay_group_name, relay_names, %Endpoint{}=endpoint) do
    RelayGroups.update_memberships_by_name(:add, relay_group_name, relay_names, endpoint)
  end

  def relay_group_add_relays_by_id(relay_group_id, relay_ids, %Endpoint{}=endpoint) do
    RelayGroups.update_memberships_by_id(:add, relay_group_id, relay_ids, endpoint)
  end

  def relay_group_remove_relays_by_name(relay_group_name, relay_names, %Endpoint{}=endpoint) do
    RelayGroups.update_memberships_by_name(:remove, relay_group_name, relay_names, endpoint)
  end

  def relay_group_remove_relays_by_id(relay_group_id, relay_ids, %Endpoint{}=endpoint) do
    RelayGroups.update_memberships_by_id(:remove, relay_group_id, relay_ids, endpoint)
  end

  def relay_group_add_bundles_by_name(relay_group_name, bundle_names, %Endpoint{}=endpoint) do
    RelayGroups.update_assignments_by_name(:add, relay_group_name, bundle_names, endpoint)
  end

  def relay_group_add_bundles_by_id(relay_group_id, bundle_ids, %Endpoint{}=endpoint) do
    RelayGroups.update_assignments_by_id(:add, relay_group_id, bundle_ids, endpoint)
  end

  def relay_group_remove_bundles_by_name(relay_group_name, bundle_names, %Endpoint{}=endpoint) do
    RelayGroups.update_assignments_by_name(:remove, relay_group_name, bundle_names, endpoint)
  end

  def relay_group_remove_bundles_by_id(relay_group_id, bundle_ids, %Endpoint{}=endpoint) do
    RelayGroups.update_assignments_by_id(:remove, relay_group_id, bundle_ids, endpoint)
  end

  def role_index(endpoint) do
    Roles.index(endpoint)
  end

  def role_show(endpoint, field) do
    Roles.show(endpoint, field)
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

  def role_add_permission(endpoint, role, permission) do
    Roles.add_permission(endpoint, role, permission)
  end

  def role_remove_permission(endpoint, role, permission) do
    Roles.remove_permission(endpoint, role, permission)
  end

  def rule_index(command, %Endpoint{}=endpoint) do
    Rules.index(command, endpoint)
  end

  def rule_create(rule_text, %Endpoint{}=endpoint) do
    Rules.create(rule_text, endpoint)
  end

  def rule_show(rule_id, %Endpoint{}=endpoint) do
    Rules.show(rule_id, endpoint)
  end

  def rule_update(rule_id, rule_text, %Endpoint{}=endpoint) do
    Rules.update(rule_id, rule_text, endpoint)
  end

  def rule_update(bundle_version_id, rule_id, rule_text, %Endpoint{}=endpoint) do
    Rules.update(bundle_version_id, rule_id, rule_text, endpoint)
  end

  def rule_delete(bundle_version_id, rule_id, %Endpoint{}=endpoint) do
    Rules.delete(bundle_version_id, rule_id, endpoint)
  end

  def rule_delete(rule_id, %Endpoint{}=endpoint) do
    Rules.delete(rule_id, endpoint)
  end

  def trigger_show_by_name(%Endpoint{}=endpoint, name) do
    Triggers.by_name(endpoint, name)
  end

  def trigger_create(%Endpoint{}=endpoint, params) do
    Triggers.create(endpoint, params)
  end

  def trigger_delete(%Endpoint{}=endpoint, id) do
    Triggers.delete(endpoint, id)
  end

  def trigger_index(%Endpoint{}=endpoint) do
    Triggers.index(endpoint)
  end

  def trigger_show(%Endpoint{}=endpoint, id) do
    Triggers.show(endpoint, id)
  end

  def trigger_update(%Endpoint{}=endpoint, id, params) do
    Triggers.update(endpoint, id, params)
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
