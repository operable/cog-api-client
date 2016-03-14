defmodule CogApi.HTTP.Roles do
  import CogApi.HTTP.Base

  alias CogApi.Endpoint
  alias CogApi.Resources.Role

  def role_index(%Endpoint{}=endpoint) do
    get(endpoint, "roles") |> format_response("roles", [%Role{}])
  end

  def role_show(%Endpoint{}=endpoint, id) do
    get(endpoint, "roles", id) |> format_response("role", %Role{})
  end

  def role_create(%Endpoint{}=endpoint, params) do
    post(endpoint, "roles", %{"role" => params})
    |> format_response("role", %Role{})
  end
end
