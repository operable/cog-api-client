defmodule CogApi.Fake.RelayGroupsTest do
  use CogApi.FakeCase

  alias CogApi.Fake.Client

  doctest CogApi.Fake.RelayGroups

  describe "relay_group_index" do
    it "returns a list of relay groups" do
      name = "Index Group"
      {:ok, _} = Client.relay_group_create(%{name: "Index Group"}, fake_endpoint)

      groups = Client.relay_group_index(fake_endpoint) |> get_value

      last_group = List.last groups
      assert present last_group.id
      assert last_group.name == name
      assert last_group.bundles == []
      assert last_group.relays == []
    end
  end

  describe "relay_group_show" do
    it "returns a list of relay groups" do
      name = "Show"
      created_group = Client.relay_group_create(%{name: name}, fake_endpoint) |> get_value

      found_group = Client.relay_group_show(created_group.id, fake_endpoint) |> get_value

      assert created_group.id == found_group.id
      assert created_group.name == found_group.name
    end
  end

  describe "relay_group_create" do
    it "returns the created relay group" do
      name = "new group"
      {:ok, relay_group} = Client.relay_group_create(%{name: name}, fake_endpoint)

      assert present relay_group.id
      assert relay_group.name == name
      assert relay_group.bundles == []
      assert relay_group.relays == []
    end
  end

  describe "relay_group_updated" do
    it "returns the updated relay group" do
      {:ok, new_relay_group} = Client.relay_group_create(%{name: "relay_group_update"}, fake_endpoint)
      {:ok, updated} = Client.relay_group_update(
        new_relay_group.id,
        %{name: "updated"},
        fake_endpoint
      )

      assert updated.name == "updated"
    end
  end

  describe "relay_group_delete" do
    it "returns :ok" do
      {:ok, relay_group} = Client.relay_group_create(%{name: "delete me"}, fake_endpoint)
      assert :ok == Client.relay_group_delete(relay_group.id, fake_endpoint)
    end

    context "when the relay group cannot be deleted" do
      it "returns an error" do
        {:error, [error]} = Client.relay_group_delete("not real", fake_endpoint)

        assert error == "The relay group could not be deleted"
      end
    end
  end
end
