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
      bundle = %Bundle{id: "id123", name: "bundle"}
      Server.create(Bundle, bundle)

      {:ok, bundles} = Client.bundle_index(valid_endpoint)

      first_bundle = List.first bundles
      assert first_bundle.id == bundle.id
      assert first_bundle.name == bundle.name
    end
  end

  describe "bundle_show" do
    it "returns the bundle" do
      config = bundle_config(%{name: "postgres"})
      bundle = Client.bundle_create(valid_endpoint, config) |> get_value

      bundle = Client.bundle_show(valid_endpoint, bundle.id) |> get_value
      assert bundle.name == "postgres"
    end

    it "includes the rules for each command" do
      command = %CogApi.Resources.Command{name: "help"}
      config = bundle_config(%{name: "postgres", commands: [command]})
      bundle = Client.bundle_create(valid_endpoint, config) |> get_value
      rule_text = "when command is postgres:help must have operable:manage_commands"
      rule_text |> Client.rule_create(valid_endpoint) |> get_value

      [rule] = Client.bundle_show(valid_endpoint, bundle.id)
      |> get_value
      |> Map.get(:commands)
      |> List.first
      |> Map.get(:rules)

      assert rule.rule == rule_text
    end
  end

  describe "bundle_create" do
    it "allows adding a new bundle" do
      config = bundle_config
      bundle = Client.bundle_create(valid_endpoint, config) |> get_value

      assert bundle.name == "bundle"
      command = List.first(bundle.commands)
      assert command.documentation == "Does a thing"
      assert Enum.map(command.rules, &(&1.rule)) == [
        "when command is bundle:test_command must have bundle:permission"
      ]
      assert present bundle.id
    end

    it "works with string keys" do
      config = to_string_keys(bundle_config)
      bundle = Client.bundle_create(valid_endpoint, config) |> get_value

      assert bundle.name == "bundle"
      command = List.first(bundle.commands)
      assert command.documentation == "Does a thing"
      assert Enum.map(command.rules, &(&1.rule)) == [
        "when command is bundle:test_command must have bundle:permission"
      ]
    end

    it "fails without valid info" do
      {:error, errors} = Client.bundle_create(valid_endpoint, %{})
      assert errors == ["Invalid bundle config"]
    end
  end

  describe "bundle_update" do
    it "returns the updated bundle" do
      config = bundle_config
      bundle = Client.bundle_create(valid_endpoint, config) |> get_value

      {:ok, updated_bundle} = Client.bundle_update(
        valid_endpoint,
        bundle.id,
        %{enabled: false}
      )

      assert updated_bundle.enabled == false
    end

    it "will allow a string for enabled" do
      config = bundle_config
      bundle = Client.bundle_create(valid_endpoint, config) |> get_value

      {:ok, updated_bundle} = Client.bundle_update(
        valid_endpoint,
        bundle.id,
        %{enabled: "true"}
      )
      assert updated_bundle.enabled == true
    end

    it "only updates the enabled attribute" do
      bundle = %Bundle{id: "id123", name: "a bundle", enabled: true}
      Server.create(Bundle, bundle)

      {:error, [error]} = Client.bundle_update(
        valid_endpoint,
        bundle.id,
        %{id: "1234", name: "not a bundle"}
      )

      assert error == "You can only enable or disable a bundle"
    end

    it "allows a way to test errors" do
      config = bundle_config
      bundle = Client.bundle_create(valid_endpoint, config) |> get_value

      {:error, [error]} = Client.bundle_update(
        valid_endpoint,
        bundle.id,
        %{enabled: "ERROR"}
      )

      assert error == "Enabled is invalid"
    end

    it "returns the updated bundle given a bundle name" do
      config = bundle_config
      bundle = Client.bundle_create(valid_endpoint, config) |> get_value

      {:ok, updated_bundle} = Client.bundle_update(
        valid_endpoint,
        %{name: bundle.name},
        %{enabled: "false"}
      )
      assert updated_bundle.enabled == false
    end

  end

  describe "bundle_delete" do
    it "returns :ok" do
      config = bundle_config
      bundle = Client.bundle_create(valid_endpoint, config) |> get_value

      assert :ok == Client.bundle_delete(
        valid_endpoint,
        bundle.id
      )
    end

    context "when the bundle cannot be deleted" do
      it "returns an error" do
        {:error, [error]} = Client.bundle_delete(valid_endpoint, "not real")

        assert error == "Resource not found for: bundles"
      end
    end
  end

  defp to_string_keys(map) do
    Enum.reduce(map, %{}, fn ({key, val}, acc) ->
      if is_map(val) do
        val = to_string_keys(val)
      end
      Map.put(acc, Atom.to_string(key), val)
    end)
  end
end
