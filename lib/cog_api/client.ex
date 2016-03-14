defmodule CogApi.Client do
  alias CogApi.Endpoint
  alias CogApi.Resources.Role

  @callback authenticate(%Endpoint{}) :: {atom, %Endpoint{}}

  @callback role_index(%Endpoint{}) :: {atom, [%Role{}]}
  @callback role_show(%Endpoint{}, String.t) :: {atom, %Role{}}
  @callback role_create(%Endpoint{}, %{}) :: {atom, %Role{}}
  @callback role_update(%Endpoint{}, String.t, %{}) :: {atom, %Role{}}
end
