defmodule CogApi.HTTP.Permissions do
  alias CogApi.Endpoint
  alias CogApi.HTTP.Base
  alias CogApi.Resources.Permission

  def index(%Endpoint{}=endpoint) do
    Base.get(endpoint, "permissions")
    |> Base.format_response("permissions", [%Permission{}])
  end

  def create(%Endpoint{}=endpoint, name) do
    Base.post(endpoint, "permissions", %{"permission" => %{"name" => name}})
    |> Base.format_response("permission", %Permission{})
  end
end
