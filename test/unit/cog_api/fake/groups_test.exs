defmodule CogApi.Fake.GroupsTest do
  use CogApi.FakeCase

  alias CogApi.Fake.Groups

  doctest CogApi.Fake.Groups

  describe "group_index" do
    it "returns a list of groups" do
      name = "foobar"
      {:ok, _ } = Groups.create(fake_endpoint, %{name: name})

      {:ok, groups} = Groups.index(fake_endpoint)

      first_group = List.first groups
      assert present first_group.id
      assert first_group.name == name
    end
  end

  describe "group_show" do
    context "when the group exists" do
      it "returns the group" do
        params = %{name: "Developers"}
        {:ok, created_group} = Groups.create(fake_endpoint, params)

        {:ok, found_group} = Groups.show(fake_endpoint, created_group.id)

        assert found_group.id == created_group.id
      end
    end
  end

  describe "create" do
    it "returns the created group" do
      name = "foobar"
      {:ok, group} = Groups.create(fake_endpoint, %{name: name})

      assert present group.id
      assert group.name == name
    end
  end
end
