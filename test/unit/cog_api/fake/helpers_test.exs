defmodule CogApi.Fake.HelpersTest do
  use CogApi.FakeCase

  import CogApi.Fake.Helpers

  describe "catch_errors" do
    context "when given a struct as the first argument" do
      it "will cause an error for any field with a value of ERROR" do
        params = %{email_address: "ERROR"}
        struct = %CogApi.Resources.User{}

        {:error, [error]} = catch_errors struct, params, fn -> :ok end

        assert error == "Email address is invalid"
      end

      it "will only verify keys that are included in the struct" do
        params = %{not_real_key: "ERROR"}
        struct = %CogApi.Resources.User{}

        response = catch_errors struct, params, fn -> :ok end

        assert response == :ok
      end
    end
  end
end
