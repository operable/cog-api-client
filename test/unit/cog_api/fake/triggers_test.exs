defmodule CogApi.Fake.TriggersTest do
  use CogApi.FakeCase

  alias CogApi.Fake.Client

  doctest CogApi.Fake.Triggers

  describe "create" do
    it "returns the created trigger" do
      params = %{name: "echo",
                 pipeline: "echo echo > chat://#general",
                 as_user: "admin",
                 timeout_sec: 1,
                 description: "Echo!"}

      {:ok, trigger} = Client.trigger_create(fake_endpoint, params)

      assert present(trigger.id)
      assert trigger.name == params.name
      assert trigger.pipeline == params.pipeline
      assert trigger.as_user == params.as_user
      assert trigger.timeout_sec == params.timeout_sec
      assert trigger.description == params.description
      assert present(trigger.invocation_url)
    end

    it "returns errors when invalid" do
      params = %{name: "ERROR"}

      {:error, errors} = Client.trigger_create(fake_endpoint, params)

      assert errors == ["Name is invalid"]
    end
  end

  describe "index" do
    it "returns a list of triggers" do
      params = %{name: "echo_stuff",
                 pipeline: "echo stuff > chat://#general",
                 as_user: "somebody",
                 timeout_sec: 60,
                 description: "Echoes stuff"}

      {:ok, _}         = Client.trigger_create(fake_endpoint, params)
      {:ok, [trigger]} = Client.trigger_index(fake_endpoint)

      assert present(trigger.id)
      assert trigger.name == params.name
      assert trigger.pipeline == params.pipeline
      assert trigger.as_user == params.as_user
      assert trigger.timeout_sec == params.timeout_sec
      assert trigger.description == params.description
    end

    it "returns a single trigger by name" do
      params = %{name: "echo_stuff_by_name",
                 pipeline: "echo stuff > chat://#general",
                 as_user: "somebody",
                 timeout_sec: 60,
                 description: "Echoes stuff"}

      {:ok, trigger}  = Client.trigger_create(fake_endpoint, params)
      assert {:ok, ^trigger} = Client.trigger_show_by_name(fake_endpoint, params[:name])
    end

    it "returns nothing if searching by an invalid name" do
      assert {:error, :not_found} = Client.trigger_show_by_name(fake_endpoint, "nothing_is_named_this")
    end
  end

  describe "show" do
    it "returns the trigger" do
      params = %{name: "echo_more_stuff",
                 pipeline: "echo 'more stuff' > chat://#general",
                 as_user: "somebody_else",
                 timeout_sec: 42,
                 description: "Echoes more stuff"}

      {:ok, created}   = Client.trigger_create(fake_endpoint, params)
      {:ok, retrieved} = Client.trigger_show(fake_endpoint, created.id)

      assert retrieved.id == created.id
    end
  end

  describe "update" do
    it "returns the updated trigger" do
      original_params = %{name: "echo_more_stuff",
                          pipeline: "echo 'more stuff' > chat://#general",
                          as_user: "somebody_else",
                          timeout_sec: 42,
                          description: "Echoes more stuff"}

      {:ok, original} = Client.trigger_create(fake_endpoint, original_params)

      update_params = %{pipeline: "echo 'so much more stuff' > chat://#general"}
      {:ok, updated} = Client.trigger_update(fake_endpoint, original.id, update_params)

      assert updated.name == original.name
      assert updated.pipeline == update_params.pipeline
    end
  end

  describe "delete" do
    it "deletes the trigger from the server" do
      params = %{name: "echo_everything",
                 pipeline: "echo 'all the things' > chat://#general",
                 as_user: "mystery_user_123",
                 timeout_sec: 100,
                 description: "Echoes all the things"}

      {:ok, trigger} = Client.trigger_create(fake_endpoint, params)

      assert :ok = Client.trigger_delete(fake_endpoint, trigger.id)

      {:ok, triggers} = Client.trigger_index(fake_endpoint)
      refute Enum.member?(triggers, trigger)
    end
  end
end
