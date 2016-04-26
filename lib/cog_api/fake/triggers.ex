defmodule CogApi.Fake.Triggers do
  import CogApi.Fake.Random
  import CogApi.Fake.Helpers

  alias CogApi.Endpoint
  alias CogApi.Fake.Server
  alias CogApi.Resources.Trigger

  use CogApi.Fake.InvalidCrudResponses

  def by_name(%Endpoint{token: nil}),
    do: Endpoint.invalid_endpoint
  def by_name(%Endpoint{}, name) do
    case Server.show_by_key(Trigger, :name, name) do
      nil ->
        {:error, :not_found}
      trigger ->
        {:ok, trigger}
    end
  end

  def index(%Endpoint{}), do: {:ok, Server.index(Trigger)}

  def show(%Endpoint{}, id), do: Server.show(Trigger, id)

  def create(%Endpoint{token: _}, params) do
    catch_errors %Trigger{}, params, fn ->
      id = random_string(8)

      new_trigger = %Trigger{}
      |> Map.merge(params)
      |> Map.put(:id, id)
      |> Map.put(:invocation_url, "http://localhost:4001/triggers/#{id}")

      {:ok, Server.create(Trigger, new_trigger)}
    end
  end

  def update(%Endpoint{token: _}, id, params) do
    catch_errors %Trigger{}, params, fn ->
      {:ok, Server.update(Trigger, id, params)}
    end
  end

  def delete(%Endpoint{token: nil}, _, _), do: Endpoint.invalid_endpoint
  def delete(%Endpoint{token: _}, id), do: Server.delete(Trigger, id)
end
