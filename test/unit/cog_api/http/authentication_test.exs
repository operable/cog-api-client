defmodule CogApi.HTTP.AuthenticationTest do
  use CogApi.HTTPCase
  doctest CogApi.HTTP.Authentication

  alias CogApi.HTTP.Authentication

  describe "authenticate" do
    context "when the username and password are valid" do
      it "returns an endpoint with the token attached" do
        cassette "authenticate_valid" do
          endpoint = %Endpoint{
            username: "admin",
            password: "password",
            host: "localhost",
            port: "4000",
          }
          {:ok, updated_endpoint} = Authentication.get_and_merge_token(endpoint)

          assert present updated_endpoint.token
        end
      end
    end

    context "when the host is unavailable" do
      it "returns a descriptive error" do
        cassette "authenticate_no_cog" do
          invalid_port = "9999"
          endpoint = %Endpoint{
            username: "admin",
            password: "password",
            host: "localhost",
            port: invalid_port,
          }
          {:no_connection_error, error_message} = Authentication.get_and_merge_token(endpoint)

          assert error_message == "An instance of cog must be running"
        end
      end
    end

    context "when the username or password is invalid" do
      it "returns a descriptive error" do
        cassette "authenticate_invalid_credentials" do
          endpoint = %Endpoint{
            username: "NOT_A_REAL_USER",
            password: "password",
            host: "localhost",
            port: "4000",
          }
          {:error, error_message} = Authentication.get_and_merge_token(endpoint)

          assert error_message == "Invalid username/password"
        end
      end
    end
  end
end
