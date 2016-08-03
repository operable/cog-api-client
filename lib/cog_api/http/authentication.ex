defmodule CogApi.HTTP.Authentication do
  import CogApi.HTTP.Base

  alias CogApi.Endpoint
  alias CogApi.HTTP.ApiResponse

  def get_and_merge_token(%Endpoint{token: nil}=endpoint) do
    post(endpoint, "token", token_params(endpoint))
    |> ApiResponse.format
    |> merge_token(endpoint)
  end

  def token_params(%Endpoint{email: email, password: password})
      when not(is_nil(email)) do
    %{email: email, password: password}
  end

  def token_params(%Endpoint{username: username, password: password}) do
    %{username: username, password: password}
  end

  defp merge_token({:ok, %{"token" => token_body}}, endpoint) do
    {:ok, %{endpoint | token: token_body["value"]}}
  end
  defp merge_token(error, _endpoint), do: error
end
