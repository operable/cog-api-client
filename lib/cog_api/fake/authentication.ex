defmodule CogApi.Fake.Authentication do
  alias CogApi.Endpoint

  def get_and_merge_token(%Endpoint{token: nil}=endpoint) do
    {:ok, %{endpoint | token: "1234"}}
  end
end
