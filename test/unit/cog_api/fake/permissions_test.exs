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

  describe "permission_delete" do
    it "allows deleting permissions in the site namespace" do
      endpoint = fake_endpoint
      name = "permission_delete"
      permission = Client.permission_create(endpoint, name) |> get_value

      assert :ok == Client.permission_delete(endpoint, permission.id)
    end

    context "when the permission is not in the site namespace" do
      it "returns an error" do
        endpoint = fake_endpoint
        name = "operable:manage_comamnds"
        manage_commands_permission = Client.permission_create(endpoint, name)
        |> get_value

        {:error, [error]} = Client.permission_delete(endpoint, manage_commands_permission.id)

        assert error == "Deleting permissions outside of the site namespace is forbidden."
      end
    end
  end
end
