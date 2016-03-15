defmodule CogApi.HTTP.Permissions do
  import CogApi.HTTP.Base

  alias CogApi.Endpoint
  alias CogApi.Resources.Permission

  def permission_index(%Endpoint{}=endpoint) do
    get(endpoint, "permissions") |> format_response("permissions", [%Permission{}])
  end

  def permission_create(%Endpoint{}=endpoint, name) do
    post(endpoint, "permissions", %{"permission" => %{"name" => name}})
    |> format_response("permission", %Permission{})
  end
end
