defmodule CogApi.Fake.PermissionsTest do
  use CogApi.FakeCase

  alias CogApi.Fake.Permissions

  doctest CogApi.Fake.Permissions

  describe "permission_index" do
    it "returns a list of permissions" do
      {:ok, _ } = Permissions.create(fake_endpoint, "custom:foobar")

      {:ok, permissions} = Permissions.index(fake_endpoint)

      first_permission = List.first permissions
      assert present first_permission.id
      assert first_permission.name == "foobar"
      assert first_permission.namespace.name == "custom"
    end
  end

  describe "permission_create" do
    it "defaults to the site namespace when no `:` is given" do
      name = "view_all_things"
      {:ok, permission} = Permissions.create(fake_endpoint, name)

      assert present permission.id
      assert permission.name == "view_all_things"
      assert present permission.namespace.id
      assert permission.namespace.name == "site"
    end

    it "allows creating permissions in specifc namespaces" do
      name = "custom:foobar"
      {:ok, permission} = Permissions.create(fake_endpoint, name)

      assert present permission.id
      assert permission.name == "foobar"
      assert present permission.namespace.id
      assert permission.namespace.name == "custom"
    end
  end
end
