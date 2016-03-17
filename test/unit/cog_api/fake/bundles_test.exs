defmodule CogApi.Fake.BundlesTest do
  use CogApi.FakeCase

  alias CogApi.Resources.Bundle
  alias CogApi.Fake.Server
  alias CogApi.Fake.Client

  doctest CogApi.Fake.Roles

  describe "bundle_index" do
    it "requires an authenticated endpoint" do
      {response, error_message} = Client.bundle_index(%Endpoint{})

      assert response == :error
      assert error_message == "You must provide an authenticated endpoint"
    end

    it "returns a list of bundles" do
      bundle = %Bundle{id: "id123", name: "a bundle"}
      Server.create(:bundles, bundle)

      {:ok, bundles} = Client.bundle_index(fake_endpoint)

      first_bundle = List.first bundles
      assert first_bundle.id == bundle.id
      assert first_bundle.name == bundle.name
    end
  end
end
