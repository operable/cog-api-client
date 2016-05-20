defmodule CogApi.HTTP.BundlesTest do
  use CogApi.HTTPCase

  alias CogApi.HTTP.Client
  alias CogApi.Resources.Permission

  doctest CogApi.HTTP.Bundles

  describe "bundle_install" do
    it "installs a new bundle" do
      cassette "bundle_install" do
        params = %{config: bundle_config(%{name: "bundle_install"})}
        bundle = Client.bundle_install(valid_endpoint, params) |> get_value

        assert present bundle.id
        assert bundle.name == "bundle_install"
      end
    end

    context "with an invalid bundle config" do
      it "installs a new bundle" do
        cassette "invalid_bundle_install" do
          params = %{bundle_config: %{}}
          {:error, errors} = Client.bundle_install(valid_endpoint, params)

          assert List.first(errors) == "Missing bundle config."
        end
      end
    end
  end

  describe "bundle_index" do
    it "returns a list of bundles" do
      cassette "bundle_index" do
        bundles = Client.bundle_index(valid_endpoint) |> get_value

        first_bundle = List.first bundles
        assert present first_bundle.id
        assert present first_bundle.name
      end
    end
  end

  describe "bundle_show" do
    it "returns the bundle" do
      cassette "bundle_show" do
        endpoint = valid_endpoint
        params = %{config: bundle_config(%{name: "bundle"})}
        installed_version = Client.bundle_install(endpoint, params) |> get_value

        bundle = Client.bundle_show(endpoint, installed_version.bundle_id) |> get_value

        assert bundle.id == installed_version.bundle_id
        assert bundle.name == "bundle"
        assert present bundle.inserted_at
        assert length(bundle.versions) > 0
      end
    end

    it "returns the bundle by name" do
      cassette "bundle_show_by_name" do
        endpoint = valid_endpoint
        params = %{config: bundle_config(%{name: "bundle_by_name"})}
        installed_version = Client.bundle_install(endpoint, params) |> get_value

        bundle = Client.bundle_show_by_name(endpoint, installed_version.name) |> get_value

        assert bundle.id == installed_version.bundle_id
        assert bundle.name == "bundle_by_name"
        assert present bundle.inserted_at
        assert length(bundle.versions) > 0
      end
    end

    it "returns the bundle version" do
      cassette "bundle_version_show" do
        endpoint = valid_endpoint
        params = %{config: bundle_config(%{name: "version"})}
        installed_version = Client.bundle_install(endpoint, params) |> get_value

        version = Client.bundle_version_show(endpoint, installed_version.bundle_id, installed_version.id) |> get_value

        assert version.id == installed_version.id
        assert version.name == installed_version.name
        assert version.enabled == false
        assert present version.inserted_at

        command = version.commands
        |> Enum.find(fn command -> command.name == "test_command" end)

        assert present command.name
        #assert present command.id
        #assert present command.documentation

        #[rule] = command.rules
        #assert rule.rule =~ "when command is bundle:test_command"

        [permission] = version.permissions
        assert Permission.full_name(permission) =~ "version:permission"
      end
    end

    it "returns the bundle version by name" do
      cassette "bundle_version_show_by_name" do
        endpoint = valid_endpoint
        params = %{config: bundle_config(%{name: "version_by_name"})}
        installed_version = Client.bundle_install(endpoint, params) |> get_value

        version = Client.bundle_version_show_by_name(endpoint, installed_version.name, installed_version.version) |> get_value

        assert version.id == installed_version.id
        assert version.name == installed_version.name
        assert version.enabled == false
        assert present version.inserted_at

        command = version.commands
        |> Enum.find(fn command -> command.name == "test_command" end)

        assert present command.name
        #assert present command.id
        #assert present command.documentation

        #[rule] = command.rules
        #assert rule.rule =~ "when command is bundle:test_command"

        [permission] = version.permissions
        assert Permission.full_name(permission) =~ "version_by_name:permission"
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

  describe "bundle_uninstall" do
    it "returns :ok" do
      cassette "bundle_uninstall" do
        endpoint = valid_endpoint
        mist_bundle = get_bundle(endpoint, "mist")
        assert :ok == Client.bundle_uninstall(endpoint, mist_bundle.id)
      end
    end

    context "when the bundle cannot be uninstalled" do
      it "returns an error" do
        cassette "bundle_uninstall_failure" do
          {:error, [error]} = Client.bundle_uninstall_by_name(valid_endpoint, "not real")

          assert error == "A bundle with the name 'not real' could not be found."
        end
      end
    end
  end
end
