defmodule CogApi.HTTP.GroupsTest do
  use CogApi.HTTPCase

  alias CogApi.HTTP.Client

  doctest CogApi.HTTP.Groups

  describe "group_index" do
    it "returns a list of groups" do
      cassette "groups_index" do
        endpoint = valid_endpoint
        {group, user, role} = create_group_with_user_and_role(endpoint, "index")

        {:ok, groups} = Client.group_index(endpoint)

        last_group = List.last groups
        assert last_group.id == group.id
        assert last_group.name == group.name
        assert last_group.users == [%{user | chat_handles: []}]
        assert last_group.roles == [role]
      end
    end
  end

  describe "group_show" do
    context "when the group exists" do
      it "returns the group" do
        cassette "group_show" do
          endpoint = valid_endpoint
          {group, user, role} = create_group_with_user_and_role(endpoint, "show_with_user")

          found_group = Client.group_show(endpoint, group.id) |> get_value

          assert found_group.id == group.id
          assert found_group.name == group.name
          assert found_group.users == [%{user | chat_handles: []}]
          assert found_group.roles == [role]
        end
      end
    end

    context "the cog-admin group" do
      it "sets modifiable to false" do
        cassette "group_cog_admin_show" do
          endpoint = valid_endpoint
          {:ok, group} = Client.group_create(valid_endpoint, %{name: "cog-admin"})

          found_group = Client.group_show(endpoint, group.id) |> get_value

          assert found_group.modifiable == false
        end
      end
    end
  end

  describe "group_find" do
    context "when the group exists" do
      it "finds and returns a group by name" do
        cassette "group_find" do
          endpoint = valid_endpoint
          group_names = ~w(group_1 group_2 group_3)

          Enum.each(group_names, fn(name) -> Client.group_create(endpoint, %{name: name}) end)
          {:ok, group} = Client.group_find(endpoint, name: Enum.at(group_names, 1))

          assert present group.id
          assert group.name == Enum.at(group_names, 1)
        end
      end
    end

    context "when the group does not exist" do
      it "returns an error tuple" do
        cassette "group_find_error" do
          response = Client.group_find(valid_endpoint, name: "lolwut")
          assert {:error, _} = response
        end
      end
    end
  end

  describe "group_create" do
    it "returns the created group" do
      cassette "groups_create" do
        name = "new group"
        {:ok, group} = Client.group_create(valid_endpoint, %{name: name})

        assert present group.id
        assert group.name == name
      end
    end
  end

  describe "group_update" do
    it "updates fields in a group and returns the updated group" do
      cassette "groups_update" do
        endpoint = valid_endpoint
        original_name = "original_group"
        updated_name = "updated_group"

        {:ok, original_group} = Client.group_create(endpoint, %{name: original_name})
        {:ok, group} = Client.group_update(endpoint, original_group.id, %{name: updated_name})

        assert group.id == original_group.id
        assert group.name == updated_name
      end
    end
  end

  describe "group_delete" do
    it "returns :ok" do
      cassette "groups_delete" do
        endpoint = valid_endpoint
        {:ok, group} = Client.group_create(endpoint, %{name: "group to delete"})
        assert :ok == Client.group_delete(endpoint, group.id)
      end
    end

    context "when the group cannot be deleted" do
      it "returns an error" do
        cassette "groups_delete_failure" do
          {:error, [error]} = Client.group_delete(valid_endpoint, "not real")

          assert error == "The group could not be deleted"
        end
      end
    end
  end

  describe "group_add_role" do
    it "returns the roles that are associated with that group" do
      cassette "group_add_role" do
        endpoint = valid_endpoint
        role = Client.role_create(endpoint, %{name: "role_grant"}) |> get_value
        group = Client.group_create(endpoint, %{name: "group_role_grant"}) |> get_value

        updated_group = Client.group_add_role(endpoint, group, role) |> get_value

        first_role = List.first updated_group.roles
        assert first_role.id == role.id
      end
    end
  end

  describe "group_remove_role" do
    it "returns the roles that are associated with that group" do
      cassette "group_remove_role" do
        endpoint = valid_endpoint
        role = Client.role_create(endpoint, %{name: "role_revoke"}) |> get_value
        group = Client.group_create(endpoint, %{name: "group_role_revoke"}) |> get_value
        group = Client.group_add_role(endpoint, group, role) |> get_value
        assert group.roles != []

        group = Client.group_remove_role(endpoint, group, role) |> get_value

        assert group.roles == []
      end
    end
  end

  describe "group_add_user" do
    it "adds the user to the group" do
      cassette "groups_add" do
        endpoint = valid_endpoint
        group = Client.group_create(endpoint, %{name: "groups_add"}) |> get_value
        user = Client.user_create(endpoint, user_params("group_add_user")) |> get_value
        assert group.users == []

        group = Client.group_add_user(endpoint, group, user) |> get_value

        assert group.users == [%{user | chat_handles: []}]
      end
    end
  end

  describe "group_remove_user" do
    it "removes the user from the group" do
      cassette "groups_remove" do
        endpoint = valid_endpoint
        {group, user} = create_group_with_user(endpoint, "group_remove_user")

        group = Client.group_remove_user(endpoint, group, user) |> get_value

        assert group.users == []
      end
    end
  end

  defp create_group_with_user(endpoint, test_name) do
    group = Client.group_create(endpoint, %{name: "group#{test_name}"}) |> get_value
    user = Client.user_create(endpoint, user_params(test_name)) |> get_value
    group = Client.group_add_user(endpoint, group, user) |> get_value

    {group, user}
  end

  defp create_group_with_user_and_role(endpoint, test_name) do
    {group, user} = create_group_with_user(endpoint, test_name)
    role = Client.role_create(endpoint, %{name: "group#{test_name}"}) |> get_value
    group = Client.group_add_role(endpoint, group, role) |> get_value

    {group, user, role}
  end
end
