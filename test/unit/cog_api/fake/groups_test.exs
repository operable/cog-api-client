defmodule CogApi.Fake.GroupsTest do
  use CogApi.FakeCase

  alias CogApi.Fake.Client

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

  describe "group_add_user" do
    it "adds the user to the group" do
      group = Client.group_create(fake_endpoint, %{name: "user_group"}) |> get_value
      user = Client.user_create(fake_endpoint, %{username: "bob"}) |> get_value
      assert group.users == []

      group = Client.group_add_user(fake_endpoint, group, user) |> get_value

      assert group.users == [user]
    end
  end
end
