defmodule CogApi.Fake.Authentication do
  alias CogApi.Endpoint

  def get_and_merge_token(%Endpoint{token: nil, password: password}=endpoint) do
    if password == "INVALID_PASSWORD" do
      {:error, ["Invalid username/password"]}
    else
      {:ok, %{endpoint | token: "1234"}}
    end
  end
end
