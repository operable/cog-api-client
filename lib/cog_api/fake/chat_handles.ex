defmodule CogApi.Fake.ChatHandles do
  import CogApi.Fake.Random
  import CogApi.Fake.Helpers

  alias CogApi.Endpoint
  alias CogApi.Fake.Server
  alias CogApi.Resources.ChatHandle

  def create(%Endpoint{token: nil}, _, _), do: Endpoint.invalid_endpoint
  def create(%Endpoint{token: _}, user_id, params) do
    catch_errors %ChatHandle{}, params, fn ->
      new_chat_handle = %ChatHandle{id: random_string(8), user_id: user_id}
      new_chat_handle = Map.merge(new_chat_handle, params)
      {:ok, Server.create(ChatHandle, new_chat_handle)}
    end
  end

  def update(%Endpoint{token: nil}, _, _), do: Endpoint.invalid_endpoint
  def update(%Endpoint{token: _}, id, params) do
    catch_errors %ChatHandle{}, params, fn ->
      {:ok, Server.update(ChatHandle, id, params)}
    end
  end

  def delete(%Endpoint{token: nil}, _, _), do: Endpoint.invalid_endpoint
  def delete(%Endpoint{token: _}, id), do: Server.delete(ChatHandle, id)

  def for_user(_, %Endpoint{token: nil}), do: Endpoint.invalid_endpoint
  def for_user(id, %Endpoint{token: _}) do
    handles = Enum.filter(Server.index(ChatHandle), &(&1.user_id == id))
    {:ok, handles}
  end
end
