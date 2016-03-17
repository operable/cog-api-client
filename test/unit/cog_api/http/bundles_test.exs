defmodule CogApi.HTTP.BundlesTest do
  use CogApi.HTTPCase

  alias CogApi.HTTP.Client

  doctest CogApi.HTTP.Bundles

  describe "bundle_index" do
    it "returns a list of bundles" do
      cassette "bundles_index" do
        bundles = Client.bundle_index(valid_endpoint) |> get_value

        first_bundle = List.first bundles
        assert present first_bundle.id
        assert present first_bundle.name
      end
    end
  end

  describe "bundle_update" do
    it "returns the updated bundle" do
      cassette "bundles_update" do
        endpoint = valid_endpoint
        mist_bundle =
          Client.bundle_index(endpoint)
          |> get_value
          |> Enum.find(fn(bundle) -> bundle.name == "mist" end)

        assert mist_bundle.enabled

        updated_bundle = Client.bundle_update(
          endpoint,
          mist_bundle.id,
          %{enabled: false}
        ) |> get_value

        assert updated_bundle.enabled == false
      end
    end
  end
end
