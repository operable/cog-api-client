defmodule CogApi.HTTP.RelayGroupsTest do
  use CogApi.HTTPCase

  alias CogApi.HTTP.Client

  doctest CogApi.HTTP.RelayGroups

  describe "relay_group_index" do
    it "returns a list of relay groups" do
      cassette "relay_group_index" do
        endpoint = valid_endpoint
        name = "Index Relay Group"
        {:ok, _} = Client.relay_group_create(%{name: name}, endpoint)

        groups = Client.relay_group_index(endpoint) |> get_value

        last_group = List.last groups

        assert present last_group.id
        assert present last_group.inserted_at
        assert present last_group.updated_at
        assert last_group.name == name
        assert last_group.bundles == []
        assert last_group.relays == []
      end
    end
  end

  describe "relay_group_show" do
    it "returns a list of relay groups" do
      cassette "relay_group_show" do
        endpoint = valid_endpoint
        name = "Show"
        created_group = Client.relay_group_create(%{name: name}, endpoint) |> get_value

        found_group = Client.relay_group_show(created_group.id, endpoint) |> get_value

        assert created_group.id == found_group.id
        assert created_group.name == found_group.name
      end
    end

    context "when passing relay group name" do
      it "returns a relay group" do
        cassette "relay_group_show_with_name" do
          endpoint = valid_endpoint
          name = "ShowName"
          created_group = Client.relay_group_create(%{name: name}, endpoint) |> get_value

          found_group = Client.relay_group_show(%{name: created_group.name}, endpoint) |> get_value

          assert created_group.id == found_group.id
          assert created_group.name == found_group.name
        end
      end
    end
  end

  describe "relay_group_create" do
    it "returns the created relay group" do
      cassette "relay_group_create" do
        name = "new group"
        relay_group = Client.relay_group_create(%{name: name}, valid_endpoint) |> get_value

        assert present relay_group.id
        assert present relay_group.inserted_at
        assert present relay_group.updated_at
        assert relay_group.name == name
        assert relay_group.bundles == []
        assert relay_group.relays == []
      end
    end
  end

  describe "relay_group_updated" do
    it "returns the updated relay group" do
      cassette "relay_group_update" do
        endpoint = valid_endpoint
        new_relay_group = Client.relay_group_create(%{name: "relay_group_update"}, endpoint)
        |> get_value

        updated = Client.relay_group_update(
          new_relay_group.id,
          %{name: "updated"},
          endpoint
        ) |> get_value

        assert updated.name == "updated"
      end
    end
  end

  describe "relay_group_delete" do
    it "returns :ok" do
      cassette "relay_group_delete" do
        endpoint = valid_endpoint
        relay_group = Client.relay_group_create(%{name: "delete me"}, endpoint)
        |> get_value

        assert :ok == Client.relay_group_delete(relay_group.id, endpoint)
      end
    end

    context "when the relay group cannot be deleted" do
      it "returns an error" do
        cassette "relay_group_delete_failure" do
          {:error, [error]} = Client.relay_group_delete("not real", valid_endpoint)

          assert error == "The relay group could not be deleted"
        end
      end
    end

    context "when given the relay group name" do
      it "returns :ok" do
        cassette "relay_group_delete_with_name" do
          endpoint = valid_endpoint
          relay_group = Client.relay_group_create(%{name: "nada"}, endpoint)
          |> get_value

          assert :ok == Client.relay_group_delete(%{name: relay_group.name}, endpoint)
        end
      end
    end

    context "when the relay group by name cannot be deleted" do
      it "returns an error" do
        cassette "relay_group_delete_failure_by_name" do
          {:error, [error]} = Client.relay_group_delete(%{name: "nada"}, valid_endpoint)

          assert error == "The relay group `nada` could not be deleted: Resource not found"
        end
      end
    end
  end

  describe "relay_group_add_bundle" do
    it "adds the bundle to the group" do
      cassette "relay_group_add_bundle" do
        endpoint = valid_endpoint
        bundle = create_bundle(endpoint, "add_bundle")
        group = Client.relay_group_create(%{name: "add_bundle"}, endpoint) |> get_value
        assert group.bundles == []

        group = Client.relay_group_add_bundle(group.id, bundle.id, endpoint) |> get_value

        [grouped_bundle] = group.bundles

        assert grouped_bundle.id == bundle.id
      end
    end

    context "when passing names" do
      it "adds bundle to the relay group" do
        cassette "relay_group_add_bundle_with_name" do
          endpoint = valid_endpoint

          bundle = create_bundle(endpoint, "add_bundle_with_name")
          group = Client.relay_group_create(%{name: "mygroup"}, endpoint) |> get_value
          assert group.bundles == []

          group = Client.relay_group_add_bundle(%{name: group.name}, %{bundle: bundle.name}, endpoint) |> get_value

          [grouped_bundle] = group.bundles

          assert grouped_bundle.id == bundle.id
        end
      end
    end
  end

  describe "relay_group_remove_bundle" do
    it "removes the bundle from the group" do
      cassette "relay_group_remove_bundle" do
        endpoint = valid_endpoint
        bundle = create_bundle(endpoint, "remove_bundle")
        group = Client.relay_group_create(%{name: "add_bundle"}, endpoint) |> get_value
        group = Client.relay_group_add_bundle(group.id, bundle.id, endpoint) |> get_value
        assert group.bundles != []

        group = Client.relay_group_remove_bundle(group.id, bundle.id, endpoint) |> get_value

        assert group.bundles == []
      end
    end

    context "when passing names" do
      it "removes bundle from the relay group" do
        cassette "relay_group_remove_bundle_with_name" do
          endpoint = valid_endpoint
          name = "remove_bundle_with_name"
          bundle = create_bundle(endpoint, name)
          group = Client.relay_group_create(%{name: name}, endpoint) |> get_value
          group = Client.relay_group_add_bundle(group.id, bundle.id, endpoint) |> get_value
          assert group.bundles != []

          group = Client.relay_group_remove_bundle(%{name: group.name},
          %{bundle: bundle.name}, endpoint) |> get_value

          assert group.bundles == []
        end
      end
    end
  end

  describe "relay_group_add_relay" do
    it "adds the relay to the group" do
      cassette "relay_group_add_relay" do
        endpoint = valid_endpoint
        relay = Client.relay_create(%{name: "relayyy", token: "1234"}, endpoint) |> get_value
        group = Client.relay_group_create(%{name: "groupyy"}, endpoint) |> get_value
        assert group.relays == []

        group = Client.relay_group_add_relay(group.id, relay.id, endpoint) |> get_value

        [grouped_relay] = group.relays

        assert grouped_relay.id == relay.id
      end
    end

    context "when passing relay group name" do
      it "adds relay to the relay group" do
        cassette "relay_group_add_with_name" do
          endpoint = valid_endpoint
          relay = Client.relay_create(%{name: "relay1", token: "1234"}, endpoint) |> get_value
          group = Client.relay_group_create(%{name: "mygroup"}, endpoint) |> get_value
          assert group.relays == []

          group = Client.relay_group_add_relay(%{name: group.name}, %{relay: relay.name}, endpoint) |> get_value

          [grouped_relay] = group.relays

          assert grouped_relay.id == relay.id
        end
      end
    end
  end

  describe "relay_group_remove_relay" do
    it "removes the relay from the group" do
      cassette "relay_group_remove_relay" do
        endpoint = valid_endpoint
        relay = Client.relay_create(%{name: "Remove", token: "1234"}, endpoint) |> get_value
        group = Client.relay_group_create(%{name: "Remove"}, endpoint) |> get_value
        group = Client.relay_group_add_relay(group.id, relay.id, endpoint) |> get_value
        assert group.relays != []

        group = Client.relay_group_remove_relay(group.id, relay.id, endpoint) |> get_value

        assert group.relays == []
      end
    end

    context "when passing relay group name" do
      it "removes relay from the relay group" do
        cassette "relay_group_remove_with_name" do
          endpoint = valid_endpoint
          relay = Client.relay_create(%{name: "relay2", token: "1234"}, endpoint) |> get_value
          group = Client.relay_group_create(%{name: "myrelays"}, endpoint) |> get_value
          group = Client.relay_group_add_relay(group.id, relay.id, endpoint) |> get_value
          assert group.relays != []

          group = Client.relay_group_remove_relay(%{name: group.name}, %{relay: relay.name}, endpoint) |> get_value

          assert group.relays == []
        end
      end
    end
  end

  defp create_bundle(endpoint, name) do
    params = %{
      "name" => name,
      "version" => "0.0.1",
      "commands" => %{
        "test_command" => %{
          "executable" => "/bin/foobar",
        },
      },
    }

    Client.bundle_create(endpoint, params) |> get_value
  end
end
