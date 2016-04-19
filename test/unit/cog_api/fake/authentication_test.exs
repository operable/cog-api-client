defmodule CogApi.Fake.AuthenticationTest do
  use CogApi.FakeCase
  doctest CogApi.Fake.Authentication

  alias CogApi.Fake.Authentication
  alias CogApi.Fake.Client

  describe "authenticate" do
    context "when the username and password are valid" do
      it "returns an endpoint with the token attached" do
        endpoint = %Endpoint{
          username: "admin",
          password: "password",
          host: "localhost",
          port: "4000",
        }
        Client.user_create(fake_endpoint, %{username: "admin"})
        {:ok, updated_endpoint} = Authentication.get_and_merge_token(endpoint)

        assert present updated_endpoint.token
      end
    end

    context "when no username is passed" do
      it "returns an endpoint with the token attached" do
        endpoint = %Endpoint{}
        {:ok, updated_endpoint} = Authentication.get_and_merge_token(endpoint)

        assert present updated_endpoint.token
      end
    end

    context "when the username or password is invalid" do
      it "returns a descriptive error" do
        endpoint = %Endpoint{
          username: "username",
          password: "INVALID_PASSWORD",
          host: "localhost",
          port: "4000",
        }
        {:error, errors} = Authentication.get_and_merge_token(endpoint)

        assert errors == ["Invalid username/password"]
      end
    end
  end
end
