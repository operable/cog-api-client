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
  end
end
