defmodule CogApi.HTTP.RolesTest do
  use CogApi.HTTPCase

  alias CogApi.HTTP.Client
  alias CogApi.Resources.Permission

  doctest CogApi.HTTP.Roles

  describe "role_index" do
    it "returns a list of roles" do
      cassette "roles_index" do
        endpoint = valid_endpoint
        params = %{name: "role_index"}
        {:ok, role} = Client.role_create(endpoint, params)

        {:ok, roles} = Client.role_index(endpoint)

        last_role = List.last(roles)
        assert last_role.id == role.id
        assert last_role.name == role.name
        assert last_role.groups == []
      end
    end
  end

  describe "role_show" do
    context "when the role exists" do
      it "returns the role" do
        cassette "roles_show" do
          endpoint = valid_endpoint
          params = %{name: "role_show"}
          {:ok, created_role} = Client.role_create(endpoint, params)

          {:ok, found_role} = Client.role_show(endpoint, created_role.id)

          assert found_role.id == created_role.id
        end
      end
    end

    context "the cog-admin role" do
      it "sets modifiable to false" do
        cassette "role_cog_admin_show" do
          endpoint = valid_endpoint
          {:ok, role} = Client.role_create(valid_endpoint, %{name: "cog-admin"})

          found_role = Client.role_show(endpoint, role.id) |> get_value

          assert found_role.modifiable == false
        end
      end
    end
  end

  describe "role_show by name" do
    context "when the role exists" do
      it "returns the role" do
        cassette "roles_show_by_name" do
          endpoint = valid_endpoint
          params = %{name: "role_show_by_name"}
          {:ok, created_role} = Client.role_create(endpoint, params)

          {:ok, found_role} = Client.role_show(endpoint, %{name: created_role.name})

          assert found_role.id == created_role.id
        end
      end
    end
  end

  describe "role_create" do
    it "returns the created role" do
      cassette "roles_create" do
        params = %{"name" => "role_create"}
        {:ok, role} = Client.role_create(valid_endpoint, params)

        assert present role.id
        assert role.name == params["name"]
      end
    end
  end

  describe "role_update" do
    it "returns the updated role" do
      cassette "role_update" do
        endpoint = valid_endpoint
        {:ok, new_role} = Client.role_create(endpoint, %{name: "role_update"})
        {:ok, updated_role} = Client.role_update(
          endpoint,
          new_role.id,
          %{name: "updated role"}
        )

        assert updated_role.name == "updated role"
      end
    end
  end

  describe "role_delete" do
    it "returns :ok" do
      cassette "role_delete" do
        endpoint = valid_endpoint
        {:ok, role} = Client.role_create(endpoint, %{name: "role_delete"})
        assert :ok == Client.role_delete(endpoint, role.id)
      end
    end
  end

  describe "role_add_permission" do
    it "adds the permission to the role" do
      cassette "role_add_permission" do
        endpoint = valid_endpoint
        role = Client.role_create(endpoint, %{name: "developer"}) |> get_value
        permission = Client.permission_create(endpoint, "write_code") |> get_value
        assert role.permissions == []

        role = Client.role_add_permission(endpoint, role, permission) |> get_value

        assert role.permissions == [permission]
      end
    end

    context "when the permission cannot be added" do
      it "returns an :error" do
        cassette "role_add_permission_fail" do
          endpoint = valid_endpoint
          role = Client.role_create(endpoint, %{name: "designer"}) |> get_value
          permission = %Permission{name: "", bundle: ""}

          {:error, error} = Client.role_add_permission(endpoint, role, permission)

          assert error == ["Not found permissions - :"]
        end
      end
    end
  end

  describe "role_remove_permission" do
    it "removes the permission from the role" do
      cassette "role_remove_permissions" do
        endpoint = valid_endpoint
        role = Client.role_create(endpoint, %{name: "developer2"}) |> get_value
        permission = Client.permission_create(endpoint, "write_code2") |> get_value
        role = Client.role_add_permission(endpoint, role, permission) |> get_value
        assert role.permissions == [permission]

        role = Client.role_remove_permission(endpoint, role, permission) |> get_value

        assert role.permissions == []
      end
    end
  end
end
