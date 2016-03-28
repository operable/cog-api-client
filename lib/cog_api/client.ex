defmodule CogApi.Client do
  alias CogApi.Endpoint

  alias CogApi.Resources.Bundle
  alias CogApi.Resources.Group
  alias CogApi.Resources.Permission
  alias CogApi.Resources.Role
  alias CogApi.Resources.Rule
  alias CogApi.Resources.User

  @callback authenticate(%Endpoint{}) :: {atom, %Endpoint{}}

  @callback bundle_index(%Endpoint{}) ::{atom, [%Bundle{}]}
  @callback bundle_show(%Endpoint{}, String.t) ::{atom, %Bundle{}}
  @callback bundle_update(%Endpoint{}, String.t, %{}) ::{atom, %Bundle{}}

  @callback group_index(%Endpoint{}) :: {atom, [%Group{}]}
  @callback group_show(%Endpoint{}, String.t) :: {atom, %Group{}}
  @callback group_create(%Endpoint{}, %{}) :: {atom, %Group{}}
  @callback group_delete(%Endpoint{}, String.t) :: atom
  @callback group_delete(%Endpoint{}, String.t) :: {atom, [String.t]}
  @callback group_add_user(%Endpoint{}, %Group{}, %User{}) :: {atom, %Group{}}
  @callback group_remove_user(%Endpoint{}, %Group{}, %User{}) :: {atom, %Group{}}

  @callback permission_index(%Endpoint{}) :: {atom, [%Permission{}]}
  @callback permission_create(%Endpoint{}, String.t) :: {atom, %Permission{}}

  @callback role_index(%Endpoint{}) :: {atom, [%Role{}]}
  @callback role_show(%Endpoint{}, String.t) :: {atom, %Role{}}
  @callback role_create(%Endpoint{}, %{}) :: {atom, %Role{}}
  @callback role_update(%Endpoint{}, String.t, %{}) :: {atom, %Role{}}
  @callback role_delete(%Endpoint{}, String.t) :: atom
  @callback role_grant(%Endpoint{}, %Role{}, %Group{}) :: {atom, %Group{}}
  @callback role_revoke(%Endpoint{}, %Role{}, %Group{}) :: {atom, %Group{}}

  @callback rule_index(String.t, %Endpoint{}) :: {atom, [%Rule{}]}
  @callback rule_create(String.t, %Endpoint{}) :: {atom, %Rule{}}
  @callback rule_delete(String.t, %Endpoint{}) :: atom
  @callback rule_delete(String.t, %Endpoint{}) :: {atom, [String.t]}

  @callback user_index(%Endpoint{}) :: {atom, [%User{}]}
  @callback user_show(%Endpoint{}, String.t) :: {atom, %User{}}
  @callback user_create(%Endpoint{}, %{}) :: {atom, %User{}}
  @callback user_update(%Endpoint{}, String.t, %{}) :: {atom, %User{}}
  @callback user_delete(%Endpoint{}, String.t) :: atom
end
