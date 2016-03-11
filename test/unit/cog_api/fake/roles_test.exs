defmodule CogApi.Fake.RolesTest do
  use CogApi.FakeCase

  doctest CogApi.Fake.Roles

  describe "role_create" do
    it "returns the created role" do
      name = "foobar"
      params = %{name: name}
      {:ok, role} = CogApi.Fake.Roles.role_create(%Endpoint{}, params)

      assert present role.id
      assert role.name == name
    end
  end

  describe "role_index" do
    it "returns a list of roles" do
      name = "foobar"
      params = %{name: name}
      CogApi.Fake.Roles.role_create(%Endpoint{}, params)

      {:ok, roles} = CogApi.Fake.Roles.role_index(%Endpoint{})

      first_role = List.first roles
      assert present first_role.id
      assert first_role.name == name
    end
  end
end
