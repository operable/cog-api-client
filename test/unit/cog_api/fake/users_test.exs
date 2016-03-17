defmodule CogApi.Fake.UsersTest do
  use CogApi.FakeCase

  alias CogApi.Fake.Users

  doctest CogApi.Fake.Users

  describe "index" do
    it "returns a list of users" do
      params = %{
        first_name: "Leo",
        last_name: "McGary",
        email_address: "cos@example.com",
        username: "chief_of_staff",
        password: "supersecret",
      }
      {:ok, _} = Users.create(fake_endpoint, params)

      {:ok, users} = Users.index(fake_endpoint)

      last_user = List.last users
      assert present last_user.id
      assert last_user.first_name == params.first_name
      assert last_user.last_name == params.last_name
      assert last_user.email_address == params.email_address
      assert last_user.username == params.username
    end
  end

  describe "create" do
    it "returns the created user" do
      params = %{
        first_name: "Leo",
        last_name: "McGary",
        email_address: "cos@example.com",
        username: "chief_of_staff",
        password: "supersecret",
      }
      {:ok, user} = Users.create(fake_endpoint, params)

      assert present user.id
      assert user.first_name == params.first_name
      assert user.last_name == params.last_name
      assert user.email_address == params.email_address
      assert user.username == params.username
    end
  end
end
