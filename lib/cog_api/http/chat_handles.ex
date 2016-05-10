defmodule CogApi.HTTP.ChatHandles do
  alias CogApi.HTTP.ApiResponse
  alias CogApi.HTTP.Base

  alias CogApi.Endpoint
  alias CogApi.Decoders.ChatHandle, as: ChatHandleDecoder

  def upsert(%Endpoint{}=endpoint, user_id, params) do
    path = "users/#{user_id}/chat_handles"
    Base.post(endpoint, path, %{chat_handle: params})
    |> ApiResponse.format_with_decoder(ChatHandleDecoder, "chat_handle")
  end

  def delete(%Endpoint{}=endpoint, id) do
    Base.delete(endpoint, "chat_handles/#{id}")
    |> ApiResponse.format
  end
end
