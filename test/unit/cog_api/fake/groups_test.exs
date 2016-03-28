defmodule CogApi.Fake.GroupsTest do
  use CogApi.FakeCase

  alias CogApi.Fake.Client
  alias CogApi.Resources.User

  doctest CogApi.Fake.Groups

  describe "group_index" do
    it "returns a list of groups" do
      name = "foobar"
      {:ok, _ } = Client.group_create(fake_endpoint, %{name: name})

      {:ok, groups} = Client.group_index(fake_endpoint)

      first_group = List.first groups
      assert present first_group.id
      assert first_group.name == name
    end
  end

  describe "group_show" do
    context "when the group exists" do
      it "returns the group" do
        params = %{name: "Developers"}
        {:ok, created_group} = Client.group_create(fake_endpoint, params)

        {:ok, found_group} = Client.group_show(fake_endpoint, created_group.id)

        assert found_group.id == created_group.id
      end
    end
  end

  describe "create" do
    it "returns the created group" do
      name = "foobar"
      {:ok, group} = Client.group_create(fake_endpoint, %{name: name})

      assert present group.id
      assert group.name == name
    end
  end

  describe "delete" do
    it "deletes the group from the server" do
      {:ok, group} = Client.group_create(fake_endpoint, %{name: "new group"})

      assert :ok == Client.group_delete(fake_endpoint, group.id)

      {:ok, groups} = Client.group_index(fake_endpoint)

      refute Enum.member?(groups, group)
    end

    context "when the group cannot be deleted" do
      it "returns an error" do
        {:error, [error]} = Client.group_delete(fake_endpoint, "not real")

        assert error == "The group could not be deleted"
      end
    end
  end

  describe "group_add_user" do
    it "adds the user to the group" do
      group = Client.group_create(fake_endpoint, %{name: "user_group"}) |> get_value
      first_user = Client.user_create(fake_endpoint, %{username: "bob"}) |> get_value
      second_user = Client.user_create(fake_endpoint, %{username: "sam"}) |> get_value
      assert group.users == []

      Client.group_add_user(fake_endpoint, group, %User{username: first_user.username}) |> get_value
      group = Client.group_add_user(fake_endpoint, group, second_user) |> get_value

      assert group.users == [first_user, second_user]
    end
  end

  describe "group_remove_user" do
    it "removes the user from the group" do
      {group, user} = create_group_with_user(fake_endpoint)

      group = Client.group_remove_user(fake_endpoint, group, user) |> get_value

      assert group.users == []
    end
  end

  def create_group_with_user(endpoint) do
    group = Client.group_create(endpoint, %{name: "Group"}) |> get_value
    user = Client.user_create(endpoint, %{username: "User"}) |> get_value
    group = Client.group_add_user(endpoint, group, user) |> get_value

    {group, user}
  end
end
