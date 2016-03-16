defmodule CogApi.HTTP.Groups do
  alias CogApi.HTTP.Base

  alias CogApi.Endpoint
  alias CogApi.Resources.Group

  def index(%Endpoint{}=endpoint) do
    Base.get(endpoint, "groups") |> Base.format_response("groups", [%Group{}])
  end

  def show(%Endpoint{}=endpoint, id) do
    Base.get(endpoint, "groups/#{id}") |> Base.format_response("group", %Group{})
  end

  def create(%Endpoint{}=endpoint, params) do
    Base.post(endpoint, "groups", %{group: params})
    |> Base.format_response("group", %Group{})
  end
end
