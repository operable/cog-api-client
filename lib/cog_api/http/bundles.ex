defmodule CogApi.HTTP.Bundles do
  alias CogApi.HTTP.Base

  alias CogApi.Endpoint
  alias CogApi.Resources.Bundle

  def index(%Endpoint{}=endpoint) do
    Base.get(endpoint, "bundles")
    |> Base.format_response("bundles", [%Bundle{}])
  end
end
