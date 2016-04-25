defmodule CogApi.HTTP.BundlesTest do
  use CogApi.HTTPCase

  alias CogApi.HTTP.Client
  alias CogApi.Resources.Permission

  doctest CogApi.HTTP.Bundles

  describe "bundle_create" do
    it "creates a new bundle" do
      cassette "bundles_create" do
        params = bundle_config(%{name: "bundle_create"})
        bundle = Client.bundle_create(valid_endpoint, params) |> get_value

        assert present bundle.id
        assert bundle.name == "bundle_create"
      end
    end

    context "with an invalid bundle config" do
      it "creates a new bundle" do
        cassette "invalid_bundles_create" do
          params = %{}
          {:error, errors} = Client.bundle_create(valid_endpoint, params)

          assert List.first(errors) == "Invalid config file."
        end
      end
    end
  end

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
        params = bundle_config(%{name: "bundle"})
        created_bundle = Client.bundle_create(endpoint, params) |> get_value

        bundle = Client.bundle_show(endpoint, created_bundle.id) |> get_value

        assert bundle.id == created_bundle.id
        assert bundle.name == created_bundle.name
        assert bundle.enabled == false
        assert bundle.modifiable == true
        assert present bundle.inserted_at
        assert present bundle.updated_at

        bundle_command = bundle.commands
        |> Enum.find(fn command -> command.name == "test_command" end)

        assert present bundle_command.id
        assert present bundle_command.name
        assert present bundle_command.documentation
        assert bundle_command.enforcing == true

        [rule] = bundle_command.rules
        assert rule.rule =~ "when command is bundle:test_command"

        [permission] = bundle.permissions
        assert Permission.full_name(permission) =~ "bundle:permission"
      end
    end

    context "for the operable bundle" do
      it "returns modifiable as false" do
        cassette "bundles_show_operable" do
          endpoint = valid_endpoint
          bundles = Client.bundle_index(endpoint) |> get_value
          operable_bundle = List.first(bundles)

          bundle = Client.bundle_show(endpoint, operable_bundle.id) |> get_value

          assert bundle.modifiable == false
        end
      end
    end
  end

  describe "bundle_update" do
    it "returns the updated bundle" do
      cassette "bundles_update" do
        endpoint = valid_endpoint
        mist_bundle = get_bundle(endpoint, "mist")

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

          mist_bundle = get_bundle(endpoint, "mist")

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
          operable_bundle = get_bundle(endpoint, "operable")

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

  describe "bundle_delete" do
    it "returns :ok" do
      cassette "bundles_delete" do
        endpoint = valid_endpoint
        mist_bundle = get_bundle(endpoint, "mist")
        assert :ok == Client.bundle_delete(endpoint, mist_bundle.id)
      end
    end

    context "when the bundle cannot be deleted" do
      it "returns an error" do
        cassette "bundles_delete_failure" do
          {:error, [error]} = Client.bundle_delete(valid_endpoint, "not real")

          assert error == "The bundle could not be deleted"
        end
      end
    end
  end
end
