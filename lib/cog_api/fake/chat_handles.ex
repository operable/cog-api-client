defmodule CogApi.Fake.ChatHandles do
  import CogApi.Fake.Random
  import CogApi.Fake.Helpers

  alias CogApi.Endpoint
  alias CogApi.Fake.Server
  alias CogApi.Resources.ChatHandle

  def create(%Endpoint{token: nil}, _, _), do: Endpoint.invalid_endpoint
  def create(%Endpoint{token: _}, _user_id, params) do
    catch_errors %ChatHandle{}, params, fn ->
      new_chat_handle = %ChatHandle{id: random_string(8)}
      new_chat_handle = Map.merge(new_chat_handle, params)
      {:ok, Server.create(ChatHandle, new_chat_handle)}
    end
  end

  def delete(%Endpoint{token: nil}, _, _), do: Endpoint.invalid_endpoint
  def delete(%Endpoint{token: _}, id) do
    Server.delete(ChatHandle, id)
    :ok
  end
end
