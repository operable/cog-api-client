defmodule CogApi.HTTP.Authentication do
  import CogApi.HTTP.Base

  alias CogApi.Endpoint

  def get_and_merge_token(%Endpoint{token: nil}=endpoint) do
    params = %{username: endpoint.username, password: endpoint.password}

    post(endpoint, "token", params)
    |> format_generic_response
    |> merge_token(endpoint)
  end

  defp merge_token({:ok, %{"token" => token_body}}, endpoint) do
    {:ok, %{endpoint | token: token_body["value"]}}
  end
  defp merge_token(error, _endpoint), do: error
end
