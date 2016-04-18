defmodule CogApi.Client do
  alias CogApi.Endpoint

  alias CogApi.Resources.Bundle
  alias CogApi.Resources.Group
  alias CogApi.Resources.Permission
  alias CogApi.Resources.Relay
  alias CogApi.Resources.RelayGroup
  alias CogApi.Resources.Role
  alias CogApi.Resources.Rule
  alias CogApi.Resources.Trigger
  alias CogApi.Resources.User

  @callback authenticate(%Endpoint{}) :: {atom, %Endpoint{}}

  @callback bundle_index(%Endpoint{}) :: {atom, [%Bundle{}]}
  @callback bundle_show(%Endpoint{}, String.t) :: {atom, %Bundle{}}
  @callback bundle_update(%Endpoint{}, String.t, %{}) :: {atom, %Bundle{}}
  @callback bundle_delete(%Endpoint{}, String.t) :: atom
  @callback bundle_create(%Endpoint{}, String.t) :: {atom, %Bundle{}}

  @callback group_index(%Endpoint{}) :: {atom, [%Group{}]}
  @callback group_show(%Endpoint{}, String.t) :: {atom, %Group{}}
  @callback group_find(%Endpoint{}, Keyword.t) :: {:ok, %Group{}} | {:error, term}
  @callback group_create(%Endpoint{}, %{}) :: {atom, %Group{}}
  @callback group_update(%Endpoint{}, String.t, %{}) :: {atom, %Group{}}
  @callback group_delete(%Endpoint{}, String.t) :: atom
  @callback group_delete(%Endpoint{}, String.t) :: {atom, [String.t]}
  @callback group_add_role(%Endpoint{}, %Group{}, %Role{}) :: {atom, %Group{}}
  @callback group_remove_role(%Endpoint{}, %Group{}, %Group{}) :: {atom, %Group{}}
  @callback group_add_user(%Endpoint{}, %Group{}, %User{}) :: {atom, %Group{}}
  @callback group_remove_user(%Endpoint{}, %Group{}, %User{}) :: {atom, %Group{}}

  @callback permission_index(%Endpoint{}) :: {atom, [%Permission{}]}
  @callback permission_create(%Endpoint{}, String.t) :: {atom, %Permission{}}

  @callback relay_index(%Endpoint{}) :: {atom, [%Relay{}]}
  @callback relay_show(String.t, %Endpoint{}) :: {atom, %Relay{}}
  @callback relay_create(%{}, %Endpoint{}) :: {atom, %Relay{}}
  @callback relay_update(String.t, %{}, %Endpoint{}) :: {atom, %Relay{}}
  @callback relay_delete(String.t, %Endpoint{}) :: atom
  @callback relay_delete(String.t, %Endpoint{}) :: {atom, [String.t]}

  @callback relay_group_index(%Endpoint{}) :: {atom, [%RelayGroup{}]}
  @callback relay_group_show(String.t, %Endpoint{}) :: {atom, %RelayGroup{}}
  @callback relay_group_create(%{}, %Endpoint{}) :: {atom, %RelayGroup{}}
  @callback relay_group_update(String.t, %{}, %Endpoint{}) :: {atom, %RelayGroup{}}
  @callback relay_group_delete(String.t, %Endpoint{}) :: atom
  @callback relay_group_delete(String.t, %Endpoint{}) :: {atom, [String.t]}
  @callback relay_group_add_relay(String.t, String.t, %Endpoint{}) :: {atom, %RelayGroup{}}
  @callback relay_group_remove_relay(String.t, String.t, %Endpoint{}) :: {atom, %RelayGroup{}}
  @callback relay_group_add_bundles(String.t, String.t | List.t, %Endpoint{}) :: {atom, %RelayGroup{}}
  @callback relay_group_add_bundles(Map.t, Map.t, %Endpoint{}) :: {atom, %RelayGroup{}}
  @callback relay_group_remove_bundles(String.t, String.t | List.t, %Endpoint{}) :: {atom, %RelayGroup{}}
  @callback relay_group_remove_bundles(Map.t, Map.t, %Endpoint{}) :: {atom, %RelayGroup{}}

  @callback role_index(%Endpoint{}) :: {atom, [%Role{}]}
  @callback role_show(%Endpoint{}, String.t) :: {atom, %Role{}}
  @callback role_create(%Endpoint{}, %{}) :: {atom, %Role{}}
  @callback role_update(%Endpoint{}, String.t, %{}) :: {atom, %Role{}}
  @callback role_delete(%Endpoint{}, String.t) :: atom
  @callback role_add_permission(%Endpoint{}, %Role{}, %Permission{}) :: {atom, %Role{}}
  @callback role_remove_permission(%Endpoint{}, %Role{}, %Permission{}) :: {atom, %Role{}}

  @callback rule_index(String.t, %Endpoint{}) :: {atom, [%Rule{}]}
  @callback rule_create(String.t, %Endpoint{}) :: {atom, %Rule{}}
  @callback rule_delete(String.t, %Endpoint{}) :: atom
  @callback rule_delete(String.t, %Endpoint{}) :: {atom, [String.t]}

  @callback trigger_show_by_name(%Endpoint{}, String.t) :: {:ok, %Trigger{}} | {:error, term}
  @callback trigger_create(%Endpoint{}, %{}) :: {:ok, %Trigger{}} | {:error, term}
  @callback trigger_delete(%Endpoint{}, String.t) :: :ok | {:error, term}
  @callback trigger_index(%Endpoint{}) :: {:ok, [%Trigger{}]} | {:error, term}
  @callback trigger_show(%Endpoint{}, String.t) :: {:ok, %Trigger{}} | {:error, term}
  @callback trigger_update(%Endpoint{}, String.t, %{}) :: {:ok, %Trigger{}} | {:error, term}

  @callback user_index(%Endpoint{}) :: {atom, [%User{}]}
  @callback user_show(%Endpoint{}, String.t) :: {atom, %User{}}
  @callback user_create(%Endpoint{}, %{}) :: {atom, %User{}}
  @callback user_update(%Endpoint{}, String.t, %{}) :: {atom, %User{}}
  @callback user_delete(%Endpoint{}, String.t) :: atom
end
