defmodule CogApi.HTTP.GroupsTest do
  use CogApi.HTTPCase

  alias CogApi.HTTP.Groups

  doctest CogApi.HTTP.Groups

  describe "group_index" do
    it "returns a list of groups" do
      cassette "groups_index" do
        {:ok, groups} = Groups.index(valid_endpoint)

        first_group = List.first groups
        assert present first_group.id
        assert present first_group.name
      end
    end
  end

  describe "group_create" do
    it "returns the created group" do
      cassette "groups_create" do
        name = "new group"
        {:ok, group} = Groups.create(valid_endpoint, %{name: name})

        assert present group.id
        assert group.name == name
      end
    end
  end
end
