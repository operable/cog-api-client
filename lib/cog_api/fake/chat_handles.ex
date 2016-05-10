defmodule CogApi.Fake.ChatHandles do
  import CogApi.Fake.Random
  import CogApi.Fake.Helpers

  alias CogApi.Endpoint
  alias CogApi.Fake.Server
  alias CogApi.Resources.User
  alias CogApi.Resources.ChatHandle

  use CogApi.Fake.InvalidCrudResponses

  def upsert(%Endpoint{token: _}, user_id, params) do
    catch_errors %ChatHandle{}, params, fn ->
      new_chat_handle = %ChatHandle{id: random_string(8), user_id: user_id}
      new_chat_handle = Map.merge(new_chat_handle, params)
      existing_handle = find_existing(user_id, params)

      if existing_handle do
        updated_handle = Server.update(ChatHandle, existing_handle.id, new_chat_handle)
        update_user_chat_handle(user_id, updated_handle)
        {:ok, updated_handle}
      else
        created_handle = Server.create(ChatHandle, new_chat_handle)
        update_user_chat_handle(user_id, created_handle)
        {:ok, created_handle}
      end
    end
  end

  defp update_user_chat_handle(user_id, handle) do
    user = Server.show!(User, user_id)
    Server.update(User, user_id, %{user | chat_handles: [handle]})
  end

  def delete(%Endpoint{token: _}, id), do: Server.delete(ChatHandle, id)

  defp find_existing(user_id, chat_handle) do
    handles = Enum.filter(Server.index(ChatHandle), &(&1.user_id == user_id))
    Enum.find(handles, &(&1.chat_provider == chat_handle.chat_provider))
  end
end
