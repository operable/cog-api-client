defmodule CogApi.HTTP.UsersTest do
  use CogApi.HTTPCase

  alias CogApi.HTTP.Client

  doctest CogApi.HTTP.Users

  describe "index" do
    it "returns a list of users" do
      cassette "users_index" do
        params = user_params("user_index")
        endpoint = valid_endpoint
        {:ok, user} = Client.user_create(endpoint, params)

        users = Client.user_index(endpoint) |> get_value

        last_user = List.last users
        assert last_user.id == user.id
        assert last_user.first_name == user.first_name
        assert last_user.last_name == user.last_name
        assert last_user.email_address == user.email_address
        assert last_user.username == user.username
      end
    end
  end

  describe "show" do
    context "when the user exists" do
      it "returns the user" do
        cassette "users_show" do
          endpoint = valid_endpoint
          params = user_params("user_show")
          created_user = Client.user_create(endpoint, params) |> get_value
          role = Client.role_create(endpoint, %{name: "user_show_role"}) |> get_value
          group = Client.group_create(endpoint, %{name: "user_show_group"}) |> get_value
          Client.group_add_role(endpoint, group, role)
          Client.group_add_user(endpoint, group, created_user)

          found_user = Client.user_show(endpoint, created_user.id) |> get_value

          assert found_user.id == created_user.id
          assert Enum.map(found_user.groups, &(&1.id)) == [group.id]
          first_group = List.first(found_user.groups)
          assert Enum.map(first_group.roles, &(&1.id)) == [role.id]
        end
      end

      it "searches by username" do
        cassette "users_show_by_username" do
          endpoint = valid_endpoint
          params = user_params("user_show_by_username")
          created_user = Client.user_create(endpoint, params) |> get_value

          found_user = Client.user_show(endpoint, %{username: created_user.username}) |> get_value

          assert found_user.id == created_user.id
          assert found_user.email_address == created_user.email_address
        end
      end

      it "finds the current user" do
        cassette "users_show_me" do
          endpoint = valid_endpoint

          found_user = Client.user_show(endpoint, "me") |> get_value

          assert found_user.username == endpoint.username
        end
      end
    end

    context "when the user does not exist" do
      it "returns an error" do
        cassette "users_show_no_user" do
          {:error, [error]} = Client.user_show(valid_endpoint, "FAKE_ID")

          assert error == "Server internal error"
        end
      end
    end
  end

  describe "create" do
    it "returns the created user" do
      cassette "users_create" do
        params = user_params("user_create")
        user = Client.user_create(valid_endpoint, params) |> get_value

        assert present user.id
        assert user.first_name == params.first_name
        assert user.last_name == params.last_name
        assert user.email_address == params.email_address
        assert user.username == params.username
      end
    end

    it "returns errors when invalid" do
      cassette "users_create_errors" do
        endpoint = valid_endpoint
        params = user_params("user_create_errors")
        Client.user_create(endpoint, params)
        params_with_same_username = %{params | first_name: "slightly different"}
        {:error, errors} = Client.user_create(endpoint,
        params_with_same_username)

        assert errors == [
          "Username has already been taken",
        ]
      end
    end
  end

  describe "update" do
    it "returns the updated user" do
      cassette "users_update" do
        params = user_params("user_update")
        endpoint = valid_endpoint
        user = Client.user_create(endpoint, params) |> get_value

        params = %{first_name: "Arnie"}
        updated_user = Client.user_update(endpoint, user.id, params) |> get_value

        assert updated_user.first_name == params.first_name
      end
    end
  end

  describe "delete" do
    it "returns :ok" do
      cassette "user_delete" do
        endpoint = valid_endpoint
        params = user_params("user_delete")
        user = Client.user_create(endpoint, params) |> get_value

        assert :ok == Client.user_delete(endpoint, user.id)

        users = Client.user_index(endpoint) |> get_value
        refute Enum.member?(users, user)
      end
    end
  end
end
