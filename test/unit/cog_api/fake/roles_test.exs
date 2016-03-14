defmodule CogApi.Fake.RolesTest do
  use CogApi.FakeCase

  alias CogApi.Fake.Roles

  doctest CogApi.Fake.Roles

  describe "role_create" do
    it "requires a token" do
      {response, error_message} = Roles.role_create(%Endpoint{}, %{name: nil})

      assert response == :error
      assert error_message == "You must provide an authenticated endpoint"
    end

    it "returns the created role" do
      name = "foobar"
      params = %{name: name}
      {:ok, role} = Roles.role_create(fake_endpoint, params)

      assert present role.id
      assert role.name == name
    end
  end

  describe "role_show" do
    context "when the role exists" do
      it "returns the role" do
        params = %{name: "QA Analyst"}
        {:ok, created_role} = Roles.role_create(fake_endpoint, params)

        {:ok, found_role} = Roles.role_show(fake_endpoint, created_role.id)

        assert found_role.id == created_role.id
      end
    end
  end

  describe "role_index" do
    it "requires an authenticated endpoint" do
      {response, error_message} = Roles.role_index(%Endpoint{})

      assert response == :error
      assert error_message == "You must provide an authenticated endpoint"
    end

    it "returns a list of roles" do
      name = "foobar"
      params = %{name: name}
      {:ok, _ } = Roles.role_create(fake_endpoint, params)

      {:ok, roles} = Roles.role_index(fake_endpoint)

      first_role = List.first roles
      assert present first_role.id
      assert first_role.name == name
    end
  end
end
