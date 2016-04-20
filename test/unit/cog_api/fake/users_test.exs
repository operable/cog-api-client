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
      role = Client.role_create(fake_endpoint, %{name: "user_show_role"}) |> get_value
      group = Client.group_create(fake_endpoint, %{name: "user_show_group"}) |> get_value
      Client.group_add_role(fake_endpoint, group, role)
      Client.group_add_user(fake_endpoint, group, created_user)

      found_user = Client.user_show(fake_endpoint, created_user.id) |> get_value

      assert found_user.id == created_user.id
      assert Enum.map(found_user.groups, &(&1.id)) == [group.id]
      assert List.first(found_user.groups).roles == [role]
    end

    it "searches by username" do
      params = %{
        first_name: "Charlie",
        last_name: "Brown",
        email_address: "charles@example.com",
        username: "aide_to_snoopy",
        password: "kicktheball",
      }
      created_user = Client.user_create(fake_endpoint, params) |> get_value
      role = Client.role_create(fake_endpoint, %{name: "dancer"}) |> get_value
      group = Client.group_create(fake_endpoint, %{name: "peanuts"}) |> get_value
      Client.group_add_role(fake_endpoint, group, role)
      Client.group_add_user(fake_endpoint, group, created_user)

      found_user = Client.user_show(
        fake_endpoint,
        %{username: created_user.username}
      ) |> get_value

      assert found_user.id == created_user.id
      assert found_user.email_address == created_user.email_address
      assert Enum.map(found_user.groups, &(&1.id)) == [group.id]
      assert List.first(found_user.groups).roles == [role]
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
      original_params = %{
        first_name: "Arnold",
        last_name: "Vinick",
        email_address: "arnold@example.com",
        username: "arnie",
        password: "12345",
      }
      new_user = Client.user_create(fake_endpoint, original_params) |> get_value

      update_params = %{first_name: "Arnie"}
      updated_user = Client.user_update(fake_endpoint, new_user.id, update_params) |> get_value

      assert updated_user.first_name == update_params.first_name
      assert updated_user.last_name == original_params.last_name
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
