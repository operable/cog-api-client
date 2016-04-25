defmodule CogApi.Fake.ServerTest do
  use CogApi.FakeCase

  alias CogApi.Resources.RelayGroup
  alias CogApi.Resources.Relay

  alias CogApi.Fake.Server

  describe "index" do
    it "expands the relationships based on the server_information" do
      relay = %Relay{id: 1}
      relay_group = %RelayGroup{id: 1, relays: [relay]}
      Server.create(Relay, relay)
      Server.create(RelayGroup, relay_group)

      [group_from_server] = Server.index(RelayGroup)

      assert group_from_server.relays == [relay]
    end
  end

  describe "show!" do
    it "expands the relationships based on the server_information" do
      relay = %Relay{id: 1}
      relay_group = %RelayGroup{id: 1, relays: [relay]}
      Server.create(RelayGroup, relay_group)
      Server.create(Relay, relay)

      group_from_server = Server.show!(RelayGroup, relay_group.id)

      assert group_from_server.relays == [relay]
    end
  end

  describe "show" do
    it "returns a tuple with the resource" do
      relay = %Relay{id: 1}
      Server.create(Relay, relay)

      {:ok, found_relay} = Server.show(Relay, 1)

      assert found_relay.id == 1
    end

    context "when the resource does not exist" do
      it "returns an error" do
        {:error, [error]} = Server.show(RelayGroup, "FAKEID")

        assert error == "Server internal error"
      end
    end
  end

  describe "show_by_key" do
    it "expands the relationships based on the server_information" do
      relay = %Relay{id: 1}
      relay_group = %RelayGroup{id: 1, relays: [relay], name: "GROUP"}
      Server.create(RelayGroup, relay_group)
      Server.create(Relay, relay)

      group_from_server = Server.show_by_key(RelayGroup, :name, relay_group.name)

      assert group_from_server.relays == [relay]
    end
  end

  describe "create" do
    it "compresses the relationships to only store the ID" do
      relay = Server.create(Relay, %Relay{id: 1})
      relay_group = %RelayGroup{id: 1, relays: [relay]}
      group = Server.create(RelayGroup, relay_group)

      assert group.relays == [relay]

      group = Server.raw_show(RelayGroup, group.id)

      assert group.relays == [relay.id]
    end
  end

  describe "update" do
    it "compresses the relationships to only store the ID" do
      relay = Server.create(Relay, %Relay{id: 1})
      group = %RelayGroup{id: 1, relays: []}
      group = Server.create(RelayGroup, group)

      group = Server.update(RelayGroup, group.id, %{group | relays: [relay]})
      assert group.relays == [relay]

      group = Server.raw_show(RelayGroup, group.id)

      assert group.relays == [relay.id]
    end
  end

  describe "delete" do
    it "returns :ok" do
      relay = Server.create(Relay, %Relay{id: 1})

      assert :ok == Server.delete(Relay, relay.id)
    end

    context "when the item does not exist" do
      it "returns an error" do
        {:error, [error]} = Server.delete(Relay, "1234")

        assert error == "Resource not found for: relays"
      end
    end
  end
end
