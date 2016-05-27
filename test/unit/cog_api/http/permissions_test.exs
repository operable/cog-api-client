defmodule CogApi.HTTP.PermissionsTest do
  use CogApi.HTTPCase

  alias CogApi.HTTP.Client

  doctest CogApi.HTTP.Permissions

  describe "permission_index" do
    it "returns a list of permissions" do
      cassette "permission_index" do
        {:ok, permissions} = Client.permission_index(valid_endpoint)

        first_permission = List.first permissions
        assert present first_permission.id
        assert present first_permission.name
        assert present first_permission.bundle
      end
    end
  end

  describe "permission_create" do
    it "returns the created permission, in the site namespace" do
      cassette "permission_create" do
        name = "permission_create"
        {:ok, permission} = Client.permission_create(valid_endpoint, name)

        assert present permission.id
        assert permission.name == name
        assert permission.bundle == "site"
      end
    end
  end

  describe "permission_delete" do
    it "allows deleting permissions in the site namespace" do
      cassette "permission_delete" do
        endpoint = valid_endpoint
        name = "permission_delete"
        permission = Client.permission_create(endpoint, name) |> get_value

        assert :ok == Client.permission_delete(endpoint, permission.id)
      end
    end

    context "when the permission is not in the site namespace" do
      it "returns an error" do
        cassette "permission_delete_non_site" do
          endpoint = valid_endpoint
          manage_commands_permission = find_command(endpoint, "operable", "manage_commands")

          {:error, [error]} = Client.permission_delete(endpoint, manage_commands_permission.id)

          assert error == "Deleting permissions outside of the site namespace is forbidden."
        end
      end
    end
  end

  def find_command(endpoint, bundle, name) do
    Client.permission_index(endpoint)
    |> get_value
    |> Enum.find(fn permission -> permission.name == name && permission.bundle == bundle end)
  end
end
