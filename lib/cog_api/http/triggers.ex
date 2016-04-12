defmodule CogApi.HTTP.Triggers do
  alias CogApi.HTTP.ApiResponse
  alias CogApi.HTTP.Base

  alias CogApi.Endpoint
  alias CogApi.Resources.Trigger

  def by_name(%Endpoint{}=endpoint, name) do
    case endpoint
    |> Base.get("triggers?#{URI.encode_query(%{"name" => name})}")
    |> ApiResponse.format(%{"triggers" => [Trigger.format]}) do
      {:ok, []} ->
        {:error, :not_found}
      {:ok, [trigger]} ->
        {:ok, trigger}
      {:error, _}=error ->
        error
    end
  end

  def create(%Endpoint{}=endpoint, params) do
    endpoint
    |> Base.post("triggers", %{trigger: params})
    |> ApiResponse.format(%{"trigger" => Trigger.format})
  end

  def delete(%Endpoint{}=endpoint, id) do
    endpoint
    |> Base.delete("triggers/#{id}")
    |> ApiResponse.format(%{"trigger" => Trigger.format})
  end

  def index(%Endpoint{}=endpoint) do
    endpoint
    |> Base.get("triggers")
    |> ApiResponse.format(%{"triggers" => [Trigger.format]})
  end

  def show(%Endpoint{}=endpoint, id) do
    endpoint
    |> Base.get("triggers/#{id}")
    |> ApiResponse.format(%{"trigger" => Trigger.format})
  end

  def update(%Endpoint{}=endpoint, id, params) do
    endpoint
    |> Base.patch("triggers/#{id}", %{trigger: params})
    |> ApiResponse.format(%{"trigger" => Trigger.format})
  end

end
