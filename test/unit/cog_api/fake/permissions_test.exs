defmodule CogApi.Fake.PermissionsTest do
  use CogApi.FakeCase

  alias CogApi.Fake.Client

  doctest CogApi.Fake.Permissions

  describe "permission_index" do
    it "returns a list of permissions" do
      {:ok, _ } = Client.permission_create(fake_endpoint, "custom:foobar")

      {:ok, permissions} = Client.permission_index(fake_endpoint)

      first_permission = List.first permissions
      assert present first_permission.id
      assert first_permission.name == "foobar"
      assert first_permission.namespace == "custom"
    end
  end

  describe "permission_create" do
    it "defaults to the site namespace when no `:` is given" do
      name = "view_all_things"
      {:ok, permission} = Client.permission_create(fake_endpoint, name)

      assert present permission.id
      assert permission.name == "view_all_things"
      assert permission.namespace == "site"
    end

    it "allows creating permissions in specifc namespaces" do
      name = "custom:foobar"
      {:ok, permission} = Client.permission_create(fake_endpoint, name)

      assert present permission.id
      assert permission.name == "foobar"
      assert permission.namespace == "custom"
    end
  end
end
