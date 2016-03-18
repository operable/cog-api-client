defmodule CogApi.HTTP.GroupsTest do
  use CogApi.HTTPCase

  alias CogApi.HTTP.Client

  doctest CogApi.HTTP.Groups

  describe "group_index" do
    it "returns a list of groups" do
      cassette "groups_index" do
        {:ok, groups} = Client.group_index(valid_endpoint)

        first_group = List.first groups
        assert present first_group.id
        assert present first_group.name
      end
    end
  end

  describe "group_show" do
    context "when the group exists" do
      it "returns the group" do
        cassette "group_show" do
          endpoint = valid_endpoint
          params = %{name: "Developers Group"}
          {:ok, created_group} = Client.group_create(endpoint, params)

          {:ok, found_group} = Client.group_show(endpoint, created_group.id)

          assert found_group.id == created_group.id
        end
      end

      it "includes the users for the group" do
        cassette "group_show_with_user" do
          endpoint = valid_endpoint
          {group, user} = create_group_with_user(endpoint, "group_show_with_user")

          group = Client.group_show(endpoint, group.id) |> get_value

          assert group.users == [user]
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

  defp user_params(test_name) do
    %{
      first_name: "Leo",
      last_name: "McGary",
      email_address: "cos#{test_name}@example.com",
      username: "chief_of_staff#{test_name}",
      password: "supersecret",
    }
  end

  defp create_group_with_user(endpoint, test_name) do
    group = Client.group_create(endpoint, %{name: "group#{test_name}"}) |> get_value
    user = Client.user_create(endpoint, user_params(test_name)) |> get_value
    group = Client.group_add_user(endpoint, group, user) |> get_value

    {group, user}
  end
end
