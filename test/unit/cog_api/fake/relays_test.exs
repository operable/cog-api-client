defmodule CogApi.Fak.RelaysTest do
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
  end

  describe "relay_show" do
    it "returns a list of relays" do
      name = "Show"
      created_relay = Client.relay_create(%{name: name, token: "1234"}, fake_endpoint) |> get_value

      found_relay = Client.relay_show(created_relay.id, fake_endpoint) |> get_value

      assert created_relay.id == found_relay.id
      assert created_relay.name == found_relay.name
    end
  end

  describe "relay_create" do
    it "returns the created relay" do
      name = "new relay"
      relay = Client.relay_create(%{name: name, token: "1234"}, fake_endpoint) |> get_value

      assert present relay.id
      assert relay.name == name
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
  end
end
