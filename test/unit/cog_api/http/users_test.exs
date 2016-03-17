defmodule CogApi.HTTP.UsersTest do
  use CogApi.HTTPCase

  alias CogApi.HTTP.Client

  doctest CogApi.HTTP.Users

  describe "index" do
    it "returns a list of users" do
      cassette "users_index" do
        params = %{
          first_name: "Leo",
          last_name: "McGary",
          email_address: "cos@example.com",
          username: "chief_of_staff",
          password: "supersecret",
        }
        endpoint = valid_endpoint
        {:ok, _} = Client.user_create(endpoint, params)

        {:ok, users} = Client.user_index(endpoint)

        last_user = List.last users
        assert present last_user.id
        assert last_user.first_name == params.first_name
        assert last_user.last_name == params.last_name
        assert last_user.email_address == params.email_address
        assert last_user.username == params.username
      end
    end
  end

  describe "create" do
    it "returns the created user" do
      cassette "users_create" do
        params = %{
          first_name: "Josiah",
          last_name: "Bartlett",
          email_address: "president@example.com",
          username: "potus",
          password: "mrpresident",
        }
        {:ok, user} = Client.user_create(valid_endpoint, params)

        assert present user.id
        assert user.first_name == params.first_name
        assert user.last_name == params.last_name
        assert user.email_address == params.email_address
        assert user.username == params.username
      end
    end
  end
end
