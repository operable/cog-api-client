defmodule CogApi.Fake.Authentication do
  alias CogApi.Endpoint

  alias CogApi.Resources.User

  def get_and_merge_token(%Endpoint{token: nil, username: username, password: password}=endpoint) do
    if password != "INVALID_PASSWORD" && user_exists?(username) do
      {:ok, %{endpoint | token: "1234"}}
    else
      {:error, ["Invalid username/password"]}
    end
  end

  defp user_exists?(username) do
    if username do
      CogApi.Fake.Server.show_by_key(User, :username, username)
    else
      true
    end
  end
end
