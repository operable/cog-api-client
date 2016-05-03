defmodule CogApi.Fake.UsersTest do
  use CogApi.FakeCase

  alias CogApi.Fake.Client
  alias CogApi.Resources.User

  doctest CogApi.Fake.Users

  describe "index" do
    it "returns a list of users" do
      params = user_params
      {:ok, _} = Client.user_create(valid_endpoint, params)

      users = Client.user_index(valid_endpoint) |> get_value

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
      params = user_params
      created_user = Client.user_create(valid_endpoint, params) |> get_value
      role = Client.role_create(valid_endpoint, %{name: "user_show_role"}) |> get_value
      group = Client.group_create(valid_endpoint, %{name: "user_show_group"}) |> get_value
      Client.group_add_role(valid_endpoint, group, role)
      Client.group_add_user(valid_endpoint, group, created_user)

      found_user = Client.user_show(valid_endpoint, created_user.id) |> get_value

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
      created_user = Client.user_create(valid_endpoint, params) |> get_value
      role = Client.role_create(valid_endpoint, %{name: "dancer"}) |> get_value
      group = Client.group_create(valid_endpoint, %{name: "peanuts"}) |> get_value
      Client.group_add_role(valid_endpoint, group, role)
      Client.group_add_user(valid_endpoint, group, created_user)

      found_user = Client.user_show(
        valid_endpoint,
        %{username: created_user.username}
      ) |> get_value

      assert found_user.id == created_user.id
      assert found_user.email_address == created_user.email_address
      assert Enum.map(found_user.groups, &(&1.id)) == [group.id]
      assert List.first(found_user.groups).roles == [role]
    end

    it "finds the current user" do
      params = %{
        first_name: "Charlie",
        last_name: "Brown",
        email_address: "charles@example.com",
        username: "aide_to_snoopy",
        password: "kicktheball",
      }
      created_user = Client.user_create(valid_endpoint, params) |> get_value

      found_user = Client.user_show(
        valid_endpoint(%{username: created_user.username}),
        "me"
      ) |> get_value

      assert found_user.id == created_user.id
      assert found_user.username == created_user.username
    end

    it "returns the user's permissions" do
      endpoint = valid_endpoint
      params = user_params("user_permissions")
      user = Client.user_create(endpoint, params) |> get_value
      permission = Client.permission_create(endpoint, "user_permissions") |> get_value
      role = Client.role_create(endpoint, %{name: "user_permissions_role"}) |> get_value
      role = Client.role_add_permission(endpoint, role, permission) |> get_value
      group = Client.group_create(endpoint, %{name: "user_permissions_group"}) |> get_value
      Client.group_add_role(endpoint, group, role)
      Client.group_add_user(endpoint, group, user)

      user = Client.user_show(endpoint, user.id) |> get_value

      assert User.permissions(user) == [permission]
    end

    context "when the user does not exist" do
      it "returns an error" do
        {:error, [error]} = Client.user_show(valid_endpoint, "FAKE_ID")

        assert error == "Server internal error"
      end
    end
  end

  describe "create" do
    it "returns the created user" do
      params = user_params
      user = Client.user_create(valid_endpoint, params) |> get_value

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
      {:error, errors} = Client.user_create(valid_endpoint, params)

      assert errors == ["Username is invalid"]
    end
  end

  describe "update" do
    it "returns the updated user" do
      original_params = user_params
      new_user = Client.user_create(valid_endpoint, original_params) |> get_value

      update_params = %{first_name: "Arnie"}
      updated_user = Client.user_update(valid_endpoint, new_user.id, update_params) |> get_value

      assert updated_user.first_name == update_params.first_name
      assert updated_user.last_name == original_params.last_name
    end
  end

  describe "delete" do
    it "deletes the user from the server" do
      user = Client.user_create(valid_endpoint, user_params) |> get_value

      response = Client.user_delete(valid_endpoint, user.id)

      users = Client.user_index(valid_endpoint) |> get_value

      assert response == :ok
      refute Enum.member?(users, user)
    end
  end

  def user_params(name \\ "Leo") do
    %{
      first_name: name,
      last_name: "McGary",
      email_address: "#{name}@example.com",
      username: "chief_of_staff",
      password: "supersecret",
    }
  end
end
