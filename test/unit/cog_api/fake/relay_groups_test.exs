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
      assert present last_group.bundles
      assert present last_group.relays
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

    context "when passing relay group name" do
      it "returns a relay group" do
        name = "ShowName"
        created_group = Client.relay_group_create(%{name: name}, fake_endpoint) |> get_value

        found_group = Client.relay_group_show(%{name: created_group.name}, fake_endpoint) |> get_value

        assert created_group.id == found_group.id
        assert created_group.name == found_group.name
      end
    end
  end

  describe "relay_group_create" do
    it "returns the created relay group" do
      name = "new group"
      {:ok, relay_group} = Client.relay_group_create(%{name: name}, fake_endpoint)

      assert present relay_group.id
      assert relay_group.name == name
      assert present relay_group.bundles
      assert present relay_group.relays
    end

    context "when given invalid params" do
      it "returns a list of errors" do
        {:error, [error]} = Client.relay_group_create(%{name: "ERROR"}, fake_endpoint)

        assert error == "Name is invalid"
      end
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

    context "when given invalid params" do
      it "returns a list of errors" do
        {:ok, relay_group} = Client.relay_group_create(%{name: "name"}, fake_endpoint)
        {:error, [error]} = Client.relay_group_update(
          relay_group.id,
          %{name: "ERROR"},
          fake_endpoint
        )

        assert error == "Name is invalid"
      end
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

    context "when given the relay group name" do
      it "returns :ok" do
        {:ok, relay_group} = Client.relay_group_create(%{name: "nada"}, fake_endpoint)
        assert :ok == Client.relay_group_delete(%{name: relay_group.name}, fake_endpoint)
      end
    end
  end

  describe "relay_group_add_relay" do
    it "adds the relay to the group" do
      relay = Client.relay_create(%{name: "relayyy", token: "1234"}, fake_endpoint) |> get_value
      group = Client.relay_group_create(%{name: "groupyy"}, fake_endpoint) |> get_value

      group = Client.relay_group_add_relay(group.id, relay.id, fake_endpoint) |> get_value

      [grouped_relay] = group.relays

      assert grouped_relay.id == relay.id

      first_group = Client.relay_show(relay.id, fake_endpoint)
        |> get_value
        |> Map.get(:groups)
        |> List.first

      assert first_group.id == group.id
    end

    it "handles a relay that was externally updated" do
      relay = Client.relay_create(%{name: "original_name", token: "1234"}, fake_endpoint) |> get_value
      group = Client.relay_group_create(%{name: "group"}, fake_endpoint) |> get_value
      group = Client.relay_group_add_relay(group.id, relay.id, fake_endpoint) |> get_value

      new_name = "updated_name"
      Client.relay_update(relay.id, %{name: new_name}, fake_endpoint)

      group = Client.relay_group_show(group.id, fake_endpoint) |> get_value
      [relay_name] = group.relays |> Enum.map(fn relay -> relay.name end)

      assert relay_name == new_name
    end

    context "when given the relay group name" do
      it "adds the relay to the group" do
        relay = Client.relay_create(%{name: "relay1", token: "1234"}, fake_endpoint) |> get_value
        group = Client.relay_group_create(%{name: "mygroup"}, fake_endpoint) |> get_value

        group = Client.relay_group_add_relay(%{name: group.name}, %{relay: relay.name}, fake_endpoint) |> get_value

        [grouped_relay] = group.relays

        assert grouped_relay.id == relay.id

        first_group = Client.relay_show(relay.id, fake_endpoint)
        |> get_value
        |> Map.get(:groups)
        |> List.first

        assert first_group.id == group.id
      end
    end
  end

  describe "relay_group_remove_relay" do
    it "removes the relay from the group" do
      relay = Client.relay_create(%{name: "relayyy", token: "1234"}, fake_endpoint) |> get_value
      group = Client.relay_group_create(%{name: "groupyy"}, fake_endpoint) |> get_value
      group = Client.relay_group_add_relay(group.id, relay.id, fake_endpoint) |> get_value
      assert group.relays != []

      group = Client.relay_group_remove_relay(group.id, relay.id, fake_endpoint) |> get_value

      assert group.relays == []

      relay_groups = Client.relay_show(relay.id, fake_endpoint)
        |> get_value
        |> Map.get(:groups)
      assert relay_groups == []
    end

    context "when given the relay group name" do
      it "reomves the relay from the group" do
        relay = Client.relay_create(%{name: "relay2", token: "1234"}, fake_endpoint) |> get_value
        group = Client.relay_group_create(%{name: "my-relays"}, fake_endpoint) |> get_value
        group = Client.relay_group_add_relay(group.id, relay.id, fake_endpoint) |> get_value
        assert group.relays != []

        group = Client.relay_group_remove_relay(%{name: group.name}, %{relay: relay.name}, fake_endpoint) |> get_value

        assert group.relays == []

        relay_groups = Client.relay_show(relay.id, fake_endpoint)
        |> get_value
        |> Map.get(:groups)
        assert relay_groups == []
      end
    end
  end

  describe "relay_group_add_bundle" do
    it "adds the bundle to the group" do
      bundle = create_bundle
      group = Client.relay_group_create(%{name: "group"}, fake_endpoint) |> get_value

      group = Client.relay_group_add_bundle(group.id, bundle.id, fake_endpoint) |> get_value

      [grouped_bundle] = group.bundles

      assert grouped_bundle.id == bundle.id

      first_group = Client.bundle_show(fake_endpoint, bundle.id)
        |> get_value
        |> Map.get(:relay_groups)
        |> List.first

      assert first_group.id == group.id
    end

    it "handles a bundle that was externally updated" do
      bundle = create_bundle(%{enabled: false})
      group = Client.relay_group_create(%{name: "group"}, fake_endpoint) |> get_value
      group = Client.relay_group_add_bundle(group.id, bundle.id, fake_endpoint) |> get_value

      Client.bundle_update(fake_endpoint, bundle.id, %{enabled: "true"})

      group = Client.relay_group_show(group.id, fake_endpoint) |> get_value
      [bundle_enabled] = group.bundles |> Enum.map(&(&1.enabled))

      assert bundle_enabled == true
    end

    context "when passed names" do
      it "adds the bundle to the relay group" do
        bundle = create_bundle
        group = Client.relay_group_create(%{name: "my-relays"}, fake_endpoint) |> get_value
        group = Client.relay_group_add_bundle(%{name: group.name}, %{bundle: bundle.name}, fake_endpoint) |> get_value
        [grouped_bundle] = group.bundles

        assert grouped_bundle.id == bundle.id

        relay_group = Client.bundle_show(fake_endpoint, bundle.id)
        |> get_value
        |> Map.get(:relay_groups)
        |> List.first

        assert relay_group.id == group.id
      end
    end
  end

  describe "relay_group_remove_bundle" do
    it "removes the bundle from the group" do
      bundle = create_bundle
      group = Client.relay_group_create(%{name: "group"}, fake_endpoint) |> get_value
      group = Client.relay_group_add_bundle(group.id, bundle.id, fake_endpoint) |> get_value
      assert group.bundles != []

      group = Client.relay_group_remove_bundle(group.id, bundle.id, fake_endpoint) |> get_value

      assert group.bundles == []

      relay_groups = Client.bundle_show(fake_endpoint, bundle.id)
        |> get_value
        |> Map.get(:relay_groups)
      assert relay_groups == []
    end

    context "when passed names" do
      it "removes the bundle from the relay group" do
        bundle = create_bundle
        group = Client.relay_group_create(%{name: "my-relays"}, fake_endpoint) |> get_value
        group = Client.relay_group_add_bundle(group.id, bundle.id, fake_endpoint) |> get_value
        assert group.bundles != []

        group = Client.relay_group_remove_bundle(%{name: group.name}, %{bundle: bundle.name}, fake_endpoint) |> get_value

        assert group.bundles == []

        relay_groups = Client.bundle_show(fake_endpoint, bundle.id)
        |> get_value
        |> Map.get(:relay_groups)
        assert relay_groups == []
      end
    end
  end
end
