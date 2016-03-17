defmodule CogApi.Fake.UsersTest do
  use CogApi.FakeCase

  alias CogApi.Fake.Client

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
      {:ok, _} = Client.user_create(fake_endpoint, params)

      {:ok, users} = Client.user_index(fake_endpoint)

      last_user = List.last users
      assert present last_user.id
      assert last_user.first_name == params.first_name
      assert last_user.last_name == params.last_name
      assert last_user.email_address == params.email_address
      assert last_user.username == params.username
    end
  end

  describe "show" do
    it "returns the user" do
      params = %{
        first_name: "Charlie",
        last_name: "Young",
        email_address: "charlie@example.com",
        username: "aide_to_potus",
        password: "thesecretest",
      }
      {:ok, created_user} = Client.user_create(fake_endpoint, params)

      {:ok, found_user} = Client.user_show(fake_endpoint, created_user.id)

      assert found_user.first_name == params.first_name
      assert found_user.last_name == params.last_name
      assert found_user.email_address == params.email_address
      assert found_user.username == params.username
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
      {:ok, user} = Client.user_create(fake_endpoint, params)

      assert present user.id
      assert user.first_name == params.first_name
      assert user.last_name == params.last_name
      assert user.email_address == params.email_address
      assert user.username == params.username
    end
  end

  describe "delete" do
    it "deletes the user from the server" do
      params = %{
        first_name: "Leo",
        last_name: "McGary",
        email_address: "cos@example.com",
        username: "chief_of_staff",
        password: "supersecret",
      }
      {:ok, user} = Client.user_create(fake_endpoint, params)

      response = Client.user_delete(fake_endpoint, user.id)

      {:ok, users} = Client.user_index(fake_endpoint)

      assert response == :ok
      refute Enum.member?(users, user)
    end
  end
end