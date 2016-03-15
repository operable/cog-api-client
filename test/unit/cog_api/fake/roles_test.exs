defmodule CogApi.Fake.RolesTest do
  use CogApi.FakeCase

  alias CogApi.Fake.Roles

  doctest CogApi.Fake.Roles

  describe "role_create" do
    it "requires a token" do
      {response, error_message} = Roles.create(%Endpoint{}, %{name: nil})

      assert response == :error
      assert error_message == "You must provide an authenticated endpoint"
    end

    it "returns the created role" do
      name = "foobar"
      params = %{name: name}
      {:ok, role} = Roles.create(fake_endpoint, params)

      assert present role.id
      assert role.name == name
    end
  end

  describe "role_show" do
    context "when the role exists" do
      it "returns the role" do
        params = %{name: "QA Analyst"}
        {:ok, created_role} = Roles.create(fake_endpoint, params)

        {:ok, found_role} = Roles.show(fake_endpoint, created_role.id)

        assert found_role.id == created_role.id
      end
    end
  end

  describe "role_index" do
    it "requires an authenticated endpoint" do
      {response, error_message} = Roles.index(%Endpoint{})

      assert response == :error
      assert error_message == "You must provide an authenticated endpoint"
    end

    it "returns a list of roles" do
      name = "foobar"
      params = %{name: name}
      {:ok, _ } = Roles.create(fake_endpoint, params)

      {:ok, roles} = Roles.index(fake_endpoint)

      first_role = List.first roles
      assert present first_role.id
      assert first_role.name == name
    end
  end

  describe "role_update" do
    it "returns the updated role" do
      {:ok, new_role} = Roles.create(fake_endpoint, %{name: "new role"})
      {:ok, updated_role} = Roles.update(
        fake_endpoint,
        new_role.id,
        %{name: "updated role"}
      )

      assert updated_role.name == "updated role"
    end
  end

  describe "role_delete" do
    it "deletes the role from the server" do
      {:ok, role} = Roles.create(fake_endpoint, %{name: "new role"})

      Roles.delete(fake_endpoint, role.id)

      {:ok, roles} = Roles.index(fake_endpoint)

      refute Enum.member?(roles, role)
    end

    it "returns :ok" do
      {:ok, role} = Roles.create(fake_endpoint, %{name: "new role"})
      assert :ok == Roles.delete(fake_endpoint, role.id)
    end
  end
end
