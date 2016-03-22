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

      users = Client.user_index(fake_endpoint) |> get_value

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
      created_user = Client.user_create(fake_endpoint, params) |> get_value

      found_user = Client.user_show(fake_endpoint, created_user.id) |> get_value

      assert found_user.id == created_user.id
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
      user = Client.user_create(fake_endpoint, params) |> get_value

      assert present user.id
      assert user.first_name == params.first_name
      assert user.last_name == params.last_name
      assert user.email_address == params.email_address
      assert user.username == params.username
    end

    it "returns errors when invalid" do
      params = %{
        username: "ERROR",
      }
      {:error, errors} = Client.user_create(fake_endpoint, params)

      assert errors == ["Username is invalid"]
    end
  end

  describe "update" do
    it "returns the updated user" do
      params = %{
        first_name: "Arnold",
        last_name: "Vinick",
        email_address: "arnold@example.com",
        username: "arnie",
        password: "12345",
      }
      new_user = Client.user_create(fake_endpoint, params) |> get_value

      params = %{first_name: "Arnie"}
      updated_user = Client.user_update(fake_endpoint, new_user.id, params) |> get_value

      assert updated_user.first_name == params.first_name
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
      user = Client.user_create(fake_endpoint, params) |> get_value

      response = Client.user_delete(fake_endpoint, user.id)

      users = Client.user_index(fake_endpoint) |> get_value

      assert response == :ok
      refute Enum.member?(users, user)
    end
  end
end
