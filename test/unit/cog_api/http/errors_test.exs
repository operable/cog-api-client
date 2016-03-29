defmodule CogApi.HTTP.ErrorsTest do
  use CogApi.HTTPCase

  alias CogApi.HTTP.Client

  describe "making a request with invalid permissions" do
    it "returns a not authorized error" do
      cassette "invalid_permissions" do
        params = %{
          first_name: "Joey",
          last_name: "Lucas",
          email_address: "joey@example.com",
          username: "pollster1",
          password: "password",
        }
        endpoint_without_permissions =
          valid_endpoint
          |> Client.user_create(params)
          |> get_value
          |> get_valid_endpoint("password")

        {:error, errors} = Client.user_index(endpoint_without_permissions)

        assert errors == ["Not authorized."]
      end
    end
  end
end
