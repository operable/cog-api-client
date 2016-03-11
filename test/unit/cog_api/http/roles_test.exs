defmodule CogApi.HTTP.RolesTest do
  use CogApi.HTTPCase
  doctest CogApi.HTTP.Roles

  describe "role_index" do
    it "returns a list of roles" do
      cassette "roles_index" do
        {:ok, roles} = CogApi.HTTP.Roles.role_index(valid_endpoint)

        first_role = List.first roles
        assert present first_role.id
        assert present first_role.name
      end
    end
  end

  describe "role_create" do
    it "returns the created role" do
      cassette "roles_create" do
        params = %{"name" => "new role"}
        {:ok, role} = CogApi.HTTP.Roles.role_create(valid_endpoint, params)

        assert present role.id
        assert role.name == "new role"
      end
    end
  end
end
