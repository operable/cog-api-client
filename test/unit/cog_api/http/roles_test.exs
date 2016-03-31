defmodule CogApi.HTTP.RolesTest do
  use CogApi.HTTPCase

  alias CogApi.HTTP.Client

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

  describe "role_grant" do
    it "returns the roles that are associated with that group" do
      cassette "role_grant" do
        endpoint = valid_endpoint
        role = Client.role_create(endpoint, %{name: "role_grant"}) |> get_value
        group = Client.group_create(endpoint, %{name: "group_role_grant"}) |> get_value

        updated_group = Client.role_grant(endpoint, role, group) |> get_value

        first_role = List.first updated_group.roles
        assert first_role.id == role.id
      end
    end
  end

  describe "role_revoke" do
    it "returns the roles that are associated with that group" do
      cassette "role_revoke" do
        endpoint = valid_endpoint
        role = Client.role_create(endpoint, %{name: "role_revoke"}) |> get_value
        group = Client.group_create(endpoint, %{name: "group_role_revoke"}) |> get_value
        group = Client.role_grant(endpoint, role, group) |> get_value
        assert group.roles != []

        group = Client.role_revoke(endpoint, role, group) |> get_value

        assert group.roles == []
      end
    end
  end
end
