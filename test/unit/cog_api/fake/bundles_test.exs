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
      Server.create(Bundle, bundle)

      {:ok, bundles} = Client.bundle_index(fake_endpoint)

      first_bundle = List.first bundles
      assert first_bundle.id == bundle.id
      assert first_bundle.name == bundle.name
    end
  end

  describe "bundle_show" do
    it "returns the bundle" do
      bundle = %Bundle{name: "postgres"}
      bundle = Client.bundle_create(fake_endpoint, bundle) |> get_value

      bundle = Client.bundle_show(fake_endpoint, bundle.id) |> get_value
      assert bundle.name == "postgres"
    end

    it "includes the rules for each command" do
      command = %CogApi.Resources.Command{name: "help"}
      bundle = %Bundle{name: "postgres", commands: [command]}
      bundle = Client.bundle_create(fake_endpoint, bundle) |> get_value
      rule_text = "when command is postgres:help must have operable:manage_commands"
      rule_text |> Client.rule_create(fake_endpoint) |> get_value

      [rule] = Client.bundle_show(fake_endpoint, bundle.id)
      |> get_value
      |> Map.get(:commands)
      |> List.first
      |> Map.get(:rules)

      assert rule.rule == rule_text
    end
  end

  describe "bundle_create" do
    it "allows adding a new bundle" do
      params = %{
        name: "a bundle",
        version: "0.0.1",
        commands: %{
          test_command: %{
            executable: "/bin/foobar"}}}

      bundle = Client.bundle_create(fake_endpoint, params) |> get_value

      assert bundle.name == "a bundle"
      assert present bundle.id
    end
  end

  describe "bundle_update" do
    it "returns the updated bundle" do
      bundle = %Bundle{name: "a bundle", enabled: true}
      bundle = Client.bundle_create(fake_endpoint, bundle) |> get_value

      {:ok, updated_bundle} = Client.bundle_update(
        fake_endpoint,
        bundle.id,
        %{enabled: false}
      )

      assert updated_bundle.enabled == false
    end

    it "will allow a string for enabled" do
      bundle = %Bundle{name: "a bundle", enabled: true}
      bundle = Client.bundle_create(fake_endpoint, bundle) |> get_value

      {:ok, updated_bundle} = Client.bundle_update(
        fake_endpoint,
        bundle.id,
        %{enabled: "false"}
      )
      assert updated_bundle.enabled == false
    end

    it "only updates the enabled attribute" do
      bundle = %Bundle{id: "id123", name: "a bundle", enabled: true}
      Server.create(Bundle, bundle)

      {:error, error} = Client.bundle_update(
        fake_endpoint,
        bundle.id,
        %{id: "1234", name: "not a bundle"}
      )

      assert error == "You can only enable or disable a bundle"
    end

    it "allows a way to test errors" do
      bundle = %Bundle{id: "id123", name: "a bundle", enabled: true}
      bundle = Client.bundle_create(fake_endpoint, bundle) |> get_value

      {:error, [error]} = Client.bundle_update(
        fake_endpoint,
        bundle.id,
        %{enabled: "ERROR"}
      )

      assert error == "Enabled is invalid"
    end

    it "returns the updated bundle given a bundle name" do
      bundle = %Bundle{name: "my bundle", enabled: true}
      bundle = Client.bundle_create(fake_endpoint, bundle) |> get_value

      {:ok, updated_bundle} = Client.bundle_update(
        fake_endpoint,
        %{name: bundle.name},
        %{enabled: "false"}
      )
      assert updated_bundle.enabled == false
    end

  end

  describe "bundle_delete" do
    it "returns :ok" do
      bundle = %Bundle{name: "a bundle"}
      bundle = Client.bundle_create(fake_endpoint, bundle) |> get_value

      assert :ok == Client.bundle_delete(
        fake_endpoint,
        bundle.id
      )
    end

    context "when the bundle cannot be deleted" do
      it "returns an error" do
        {:error, [error]} = Client.bundle_delete(fake_endpoint, "not real")

        assert error == "The bundle could not be deleted"
      end
    end
  end
end
