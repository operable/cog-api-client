defmodule CogApi.HTTP.RelaysTest do
  use CogApi.HTTPCase

  alias CogApi.HTTP.Client

  doctest CogApi.HTTP.Relays

  describe "relay_index" do
    it "returns a list of relays" do
      cassette "relay_index" do
        endpoint = valid_endpoint
        name = "Index"
        {:ok, _} = Client.relay_create(%{name: name, token: "1234"}, endpoint)

        relays = Client.relay_index(endpoint) |> get_value

        last_relay = List.last relays

        assert present last_relay.id
        assert present last_relay.inserted_at
        assert present last_relay.updated_at
        assert last_relay.name == name
        assert last_relay.enabled == false
      end
    end

    it "includes the group for the relay" do
      cassette "relay_index_with_group" do
        endpoint = valid_endpoint
        name = "IndexGroup"
        relay = Client.relay_create(%{name: name, token: "1234"}, endpoint) |> get_value
        group = Client.relay_group_create(%{name: name}, endpoint) |> get_value
        group = Client.relay_group_add_relays_by_id(group.id, relay.id, endpoint) |> get_value

        last_relay = Client.relay_index(endpoint) |> get_value |> List.last

        [relay_group] = last_relay.groups

        assert relay_group.id == group.id
      end
    end
  end

  describe "relay_show" do
    it "returns a list of relays" do
      cassette "relay_show" do
        endpoint = valid_endpoint
        name = "Show"
        params = %{name: name, token: "1234", enabled: true, description: "This is a test"}
        created_relay = Client.relay_create(params, endpoint) |> get_value

        found_relay = Client.relay_show(created_relay.id, endpoint) |> get_value

        assert created_relay.id == found_relay.id
        assert created_relay.name == found_relay.name
        assert created_relay.enabled == true
      end
    end

    context "when given a relay name" do
      it "returns a relay" do
        cassette "relay_show_with_name" do
          endpoint = valid_endpoint
          name = "ShowName"
          params = %{name: name, token: "1234", enabled: true, description: "This is a test"}
          created_relay = Client.relay_create(params, endpoint) |> get_value

          found_relay = Client.relay_show(%{name: created_relay.name}, endpoint) |> get_value

          assert created_relay.id == found_relay.id
          assert created_relay.name == found_relay.name
          assert found_relay.enabled == true
          assert found_relay.description == "This is a test"
          assert present found_relay.inserted_at
        end
      end
    end
  end

  describe "relay_create" do
    it "returns the created relay" do
      cassette "relay_create" do
        name = "new relay"
        relay = Client.relay_create(%{name: name, token: "1234"}, valid_endpoint) |> get_value

        assert present relay.id
        assert present relay.inserted_at
        assert present relay.updated_at
        assert relay.name == name
      end
    end

    context "when given invalid params" do
      it "returns a list of errors" do
        cassette "relay_create_invalid" do
          name = "invalid relay"
          {:error, [error]} = Client.relay_create(%{name: name}, valid_endpoint)

          assert error == "Token can't be blank"
        end
      end
    end
  end

  describe "relay_updated" do
    it "returns the updated relay" do
      cassette "relay_update" do
        endpoint = valid_endpoint
        new_relay = Client.relay_create(%{name: "new_relay", token: "1234"}, endpoint)
        |> get_value

        assert new_relay.description == nil
        updated = Client.relay_update(
          new_relay.id,
          %{description: "Hello"},
          endpoint
        ) |> get_value

        assert updated.description == "Hello"
      end
    end

    context "when given invalid params" do
      it "returns a list of errors" do
        cassette "relay_update_invalid" do
          name = "invalid update relay"
          endpoint = valid_endpoint
          relay = Client.relay_create(%{name: name, token: "1234"}, endpoint) |> get_value
          {:error, [error]} = Client.relay_update(
            relay.id,
            %{name: ""},
            endpoint
          )

          assert error == "Name can't be blank"
        end
      end
    end

    context "when given a relay name" do
      it "returns the updated relay" do
        cassette "relay_update_with_name" do
          endpoint = valid_endpoint
          new_relay = Client.relay_create(%{name: "my_relay", token: "1234"}, endpoint)
          |> get_value

          assert new_relay.description == nil

          updated = Client.relay_update(
            %{name: new_relay.name},
            %{description: "Hello"},
            endpoint
          ) |> get_value

          assert updated.description == "Hello"
        end
      end
    end
  end

  describe "relay_delete" do
    it "returns :ok" do
      cassette "relay_delete" do
        endpoint = valid_endpoint
        relay = Client.relay_create(%{name: "delete me", token: "1234"}, endpoint)
        |> get_value

        assert :ok == Client.relay_delete(relay.id, endpoint)
      end
    end

    context "when the relay cannot be deleted" do
      it "returns an error" do
        cassette "relay_delete_failure" do
          {:error, [error]} = Client.relay_delete("not real", valid_endpoint)

          assert error == "The relay could not be deleted"
        end
      end
    end

    context "when passing the relay name" do
      it "returns :ok" do
        cassette "relay_delete_with_name" do
          endpoint = valid_endpoint
          relay = Client.relay_create(%{name: "delete me", token: "1234"}, endpoint)
          |> get_value

          assert :ok == Client.relay_delete(%{name: relay.name}, endpoint)
        end
      end
    end

    context "when the relay by name cannot be deleted" do
      it "returns an error" do
        cassette "relay_delete_failure_by_name" do
          {:error, [error]} = Client.relay_delete(%{name: "nada"}, valid_endpoint)

          assert error == "The relay `nada` could not be deleted: Resource not found for: 'relays'"
        end
      end
    end
  end
end
