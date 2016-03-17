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
        namespace = first_permission.namespace
        assert present namespace.id
        assert present namespace.name
      end
    end
  end

  describe "permission_create" do
    it "returns the created permission, in the site namespace" do
      cassette "permission_create" do
        name = "foobar"
        {:ok, permission} = Client.permission_create(valid_endpoint, name)

        assert present permission.id
        assert permission.name == "foobar"
        assert permission.namespace.name == "site"
      end
    end
  end
end
