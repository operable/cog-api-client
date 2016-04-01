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

  describe "bundle_show" do
    it "returns the bundle" do
      cassette "bundles_show" do
        endpoint = valid_endpoint
        bundles = Client.bundle_index(endpoint) |> get_value
        operable_bundle = List.first(bundles)

        bundle = Client.bundle_show(endpoint, operable_bundle.id) |> get_value

        assert bundle.id == operable_bundle.id
        assert bundle.name == operable_bundle.name
        assert bundle.enabled == true
        assert present bundle.inserted_at
        assert present bundle.updated_at

        bundle_command = bundle.commands
        |> Enum.find(fn command -> command.name == "bundle" end)

        assert present bundle_command.id
        assert present bundle_command.name
        assert present bundle_command.documentation

        [rule] = bundle_command.rules
        assert rule.rule =~ "when command is operable:bundle"
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

    context "when given a bundle name to be updated" do
      it "returns the updated bundle" do
        cassette "bundles_update" do
          endpoint = valid_endpoint

          mist_bundle = Client.bundle_index(endpoint)
            |> get_value
            |> Enum.find(fn(bundle) -> bundle.name == "mist" end)

          assert mist_bundle.enabled

          updated_bundle = Client.bundle_update(
              endpoint,
              %{name: mist_bundle.name},
              %{enabled: false}
            ) |> get_value

          assert updated_bundle.enabled == false
        end
      end
    end

    context "when the bundle cannot be update" do
      it "returns errors" do
        cassette "bundles_update_invalid" do
          endpoint = valid_endpoint
          operable_bundle =
            Client.bundle_index(endpoint)
            |> get_value
            |> Enum.find(fn(bundle) -> bundle.name == "operable" end)

          assert operable_bundle.enabled

          {response, [error]} = Client.bundle_update(
            endpoint,
            operable_bundle.id,
            %{enabled: false}
          )

          assert response == :error
          assert error =~ "Cannot modify"
        end
      end
    end
  end
end
