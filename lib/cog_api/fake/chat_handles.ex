defmodule CogApi.Fake.ChatHandles do
  import CogApi.Fake.Random
  import CogApi.Fake.Helpers

  alias CogApi.Endpoint
  alias CogApi.Fake.Server
  alias CogApi.Resources.ChatHandle

  use CogApi.Fake.InvalidCrudResponses

  def upsert(%Endpoint{token: _}=endpoint, user_id, params) do
    catch_errors %ChatHandle{}, params, fn ->
      new_chat_handle = %ChatHandle{id: random_string(8), user_id: user_id}
      new_chat_handle = Map.merge(new_chat_handle, params)
      existing_handle = find_existing(user_id, endpoint, params)

      if existing_handle do
        {:ok, Server.update(ChatHandle, existing_handle.id, new_chat_handle)}
      else
        {:ok, Server.create(ChatHandle, new_chat_handle)}
      end
    end
  end

  def delete(%Endpoint{token: _}, id), do: Server.delete(ChatHandle, id)

  def for_user(_, %Endpoint{token: nil}), do: Endpoint.invalid_endpoint
  def for_user(id, %Endpoint{token: _}) do
    handles = Enum.filter(Server.index(ChatHandle), &(&1.user_id == id))
    {:ok, handles}
  end

  defp find_existing(user_id, endpoint, chat_handle) do
    {:ok, handles} = for_user(user_id, endpoint)
    Enum.find(handles, &(&1.chat_provider == chat_handle.chat_provider))
  end
end
