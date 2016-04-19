defmodule CogApi.Fake.RelaysTest do
  use CogApi.FakeCase

  alias CogApi.Fake.Client

  doctest CogApi.Fake.Relays

  describe "relay_index" do
    it "returns a list of relays" do
      name = "Index"
      {:ok, _} = Client.relay_create(%{name: name, token: "1234"}, fake_endpoint)

      relays = Client.relay_index(fake_endpoint) |> get_value

      last_relay = List.last relays

      assert present last_relay.id
      assert last_relay.name == name
    end

    it "includes the group for the relay" do
      relay = Client.relay_create(%{name: "relay", token: "1234"}, fake_endpoint) |> get_value
      group = Client.relay_group_create(%{name: "group"}, fake_endpoint) |> get_value
      group = Client.relay_group_add_relay(group.id, relay.id, fake_endpoint) |> get_value

      last_relay = Client.relay_index(fake_endpoint) |> get_value |> List.last

      [relay_group] = last_relay.groups

      assert relay_group.id == group.id
    end
  end

  describe "relay_show" do
    it "returns a list of relays" do
      params = %{name: "Show", token: "1234", enabled: true, description: "This is a test"}
      created_relay = Client.relay_create(params, fake_endpoint) |> get_value

      found_relay = Client.relay_show(created_relay.id, fake_endpoint) |> get_value

      assert created_relay.id == found_relay.id
      assert created_relay.name == found_relay.name
      assert created_relay.enabled == true
      assert created_relay.description == found_relay.description
    end

    context "when given a name instead of an id" do
      it "returns a relay" do
        params = %{name: "Show", token: "1234", enabled: true,
                   description: "This is a test", inserted_at: "Some date"}
        created_relay = Client.relay_create(params, fake_endpoint) |> get_value

        found_relay = Client.relay_show(%{name: created_relay.name}, fake_endpoint) |> get_value

        assert created_relay.id == found_relay.id
        assert created_relay.name == found_relay.name
        assert created_relay.enabled == true
        assert created_relay.description == found_relay.description
      end
    end
  end

  describe "relay_create" do
    it "returns the created relay" do
      name = "new relay"
      relay = Client.relay_create(%{name: name, token: "1234"}, fake_endpoint) |> get_value

      assert present relay.id
      assert relay.name == name
    end

    context "when given invalid params" do
      it "returns a list of errors" do
        name = "invalid relay"
        {:error, [error]} = Client.relay_create(%{name: name, enabled: "ERROR"}, fake_endpoint)

        assert error == "Enabled is invalid"
      end
    end
  end

  describe "relay_updated" do
    it "returns the updated relay" do
      new_relay = Client.relay_create(%{name: "new_relay", token: "1234"}, fake_endpoint)
      |> get_value

      updated = Client.relay_update(
        new_relay.id,
        %{name: "updated"},
        fake_endpoint
      ) |> get_value

      assert updated.name == "updated"
    end

    context "when given invalid params" do
      it "returns a list of errors" do
        name = "invalid update relay"
        relay = Client.relay_create(%{name: name, token: "1234"}, fake_endpoint) |> get_value
        {:error, [error]} = Client.relay_update(
          relay.id,
          %{name: "ERROR"},
          fake_endpoint
        )

        assert error == "Name is invalid"
      end
    end

    context "when given a relay name" do
      it "returns the updated relay" do
        new_relay = Client.relay_create(%{name: "new_relay", token: "1234"}, fake_endpoint)
        |> get_value

        assert new_relay.description == nil

        updated = Client.relay_update(
          %{name: new_relay.name},
          %{description: "Hello"},
          fake_endpoint
        ) |> get_value

        assert updated.description == "Hello"
      end
    end
  end

  describe "relay_delete" do
    it "returns :ok" do
      relay = Client.relay_create(%{name: "delete me", token: "1234"}, fake_endpoint)
      |> get_value

      assert :ok == Client.relay_delete(relay.id, fake_endpoint)
    end

    context "when the relay  cannot be deleted" do
      it "returns an error" do
        {:error, [error]} = Client.relay_delete("not real", fake_endpoint)

        assert error == "The relay could not be deleted"
      end
    end

    context "when given a name instead of an id" do
      it "returns :ok" do
        relay = Client.relay_create(%{name: "delete me", token: "1234"}, fake_endpoint)
        |> get_value

        assert :ok == Client.relay_delete(%{name: relay.name}, fake_endpoint)
      end
    end
  end
end
