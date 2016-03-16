defmodule CogApi.HTTP.BundlesTest do
  use CogApi.HTTPCase

  alias CogApi.HTTP.Bundles

  doctest CogApi.HTTP.Bundles

  describe "bundle_index" do
    it "returns a list of bundles" do
      cassette "bundles_index" do
        {:ok, bundles} = Bundles.index(valid_endpoint)

        first_bundle = List.first bundles
        assert present first_bundle.id
        assert present first_bundle.name
      end
    end
  end
end
