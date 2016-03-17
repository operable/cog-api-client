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
        cassette "groups_show" do
          endpoint = valid_endpoint
          params = %{name: "Developers"}
          {:ok, created_group} = Client.group_create(endpoint, params)

          {:ok, found_group} = Client.group_show(endpoint, created_group.id)

          assert found_group.id == created_group.id
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
end
