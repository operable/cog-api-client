defmodule CogApi.HTTP.GroupsTest do
  use CogApi.HTTPCase

  alias CogApi.HTTP.Client

  doctest CogApi.HTTP.Groups

  describe "group_index" do
    it "returns a list of groups" do
      cassette "groups_index" do
        endpoint = valid_endpoint
        {group, user} = create_group_with_user(endpoint, "index")

        {:ok, groups} = Client.group_index(endpoint)

        last_group = List.last groups
        assert last_group.id == group.id
        assert last_group.name == group.name
        assert last_group.users == [user]
      end
    end
  end

  describe "group_show" do
    context "when the group exists" do
      it "returns the group" do
        cassette "group_show" do
          endpoint = valid_endpoint
          {group, user} = create_group_with_user(endpoint, "show_with_user")

          found_group = Client.group_show(endpoint, group.id) |> get_value

          assert found_group.id == group.id
          assert found_group.name == group.name
          assert found_group.users == [user]
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

  describe "group_add_user" do
    it "adds the user to the group" do
      cassette "groups_add" do
        endpoint = valid_endpoint
        group = Client.group_create(endpoint, %{name: "groups_add"}) |> get_value
        user = Client.user_create(endpoint, user_params("group_add_user")) |> get_value
        assert group.users == []

        group = Client.group_add_user(endpoint, group, user) |> get_value

        assert group.users == [user]
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
end
