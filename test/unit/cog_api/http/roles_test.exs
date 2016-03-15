defmodule CogApi.HTTP.RolesTest do
  use CogApi.HTTPCase

  alias CogApi.HTTP.Roles

  doctest CogApi.HTTP.Roles

  describe "role_index" do
    it "returns a list of roles" do
      cassette "roles_index" do
        {:ok, roles} = Roles.index(valid_endpoint)

        first_role = List.first roles
        assert present first_role.id
        assert present first_role.name
      end
    end
  end

  describe "role_show" do
    context "when the role exists" do
      it "returns the role" do
        cassette "roles_show" do
          endpoint = valid_endpoint
          params = %{name: "QA Analyst"}
          {:ok, created_role} = Roles.create(endpoint, params)

          {:ok, found_role} = Roles.show(endpoint, created_role.id)

          assert found_role.id == created_role.id
        end
      end
    end
  end

  describe "role_create" do
    it "returns the created role" do
      cassette "roles_create" do
        params = %{"name" => "new role"}
        {:ok, role} = Roles.create(valid_endpoint, params)

        assert present role.id
        assert role.name == "new role"
      end
    end
  end

  describe "role_update" do
    it "returns the updated role" do
      cassette "role_update" do
        endpoint = valid_endpoint
        {:ok, new_role} = Roles.create(endpoint, %{name: "new role"})
        {:ok, updated_role} = Roles.update(
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
        {:ok, role} = Roles.create(endpoint, %{name: "role to delete"})
        assert :ok == Roles.delete(endpoint, role.id)
      end
    end
  end
end
