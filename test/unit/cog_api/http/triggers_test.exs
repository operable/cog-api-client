defmodule CogApi.HTTP.TriggersTest do
  use CogApi.HTTPCase

  alias CogApi.HTTP.Client

  doctest CogApi.HTTP.Triggers


  describe "create" do
    it "returns the created trigger" do
      cassette "triggers_create" do
        params = trigger_params("trigger_create")
        {:ok, trigger} = Client.trigger_create(valid_endpoint, params)

        assert present(trigger.id)
        assert trigger.name == params.name
        assert trigger.pipeline == params.pipeline
        assert trigger.as_user == params.as_user
        assert trigger.timeout_sec == params.timeout_sec
        assert trigger.description == params.description
        assert present(trigger.invocation_url)
      end
    end

    it "returns errors when invalid" do
      cassette "triggers_create_errors" do
        endpoint = valid_endpoint
        params = trigger_params("trigger_create_errors")
        Client.trigger_create(endpoint, params)
        params_with_same_name =
          %{params | pipeline: "echo 'something else altogether' > chat://#general"}
        {:error, errors} = Client.trigger_create(endpoint,
                                                 params_with_same_name)
        assert errors == ["Name has already been taken"]
      end
    end
  end

  describe "index" do
    it "returns a list of triggers" do
      cassette "triggers_index" do
        params = trigger_params("trigger_index")
        endpoint = valid_endpoint

        {:ok, trigger}  = Client.trigger_create(endpoint, params)
        {:ok, triggers} = Client.trigger_index(endpoint)

        assert Enum.member?(triggers, trigger)
      end
    end

    it "returns a single trigger by name" do
      cassette "triggers_search" do
        params = trigger_params("trigger_search")
        endpoint = valid_endpoint

        {:ok, trigger}  = Client.trigger_create(endpoint, params)
        assert {:ok, ^trigger} = Client.trigger_by_name(endpoint, params[:name])
      end
    end

    it "returns nothing if searching by an invalid name" do
      cassette "triggers_search_error" do
        endpoint = valid_endpoint
        assert {:error, :not_found} = Client.trigger_by_name(endpoint, "nothing_is_named_this")
      end
    end
  end

  describe "show" do
    context "when the trigger exists" do
      it "returns the trigger" do
        cassette "triggers_show" do
          endpoint = valid_endpoint
          params = trigger_params("trigger_show")

          {:ok, created} = Client.trigger_create(endpoint, params)
          {:ok, found}   = Client.trigger_show(endpoint, created.id)

          assert found.id == created.id
        end
      end
    end
  end

  describe "update" do
    it "returns the updated trigger" do
      cassette "triggers_update" do
        params = trigger_params("trigger_update")
        endpoint = valid_endpoint
        {:ok, original} = Client.trigger_create(endpoint, params)

        params = %{pipeline: "echo 'something that nobody has ever echoed before' > chat://#general"}
        {:ok, updated} = Client.trigger_update(endpoint, original.id, params)

        assert updated.pipeline == params.pipeline
      end
    end
  end

  describe "delete" do
    it "returns :ok" do
      cassette "trigger_delete" do
        endpoint = valid_endpoint
        params = trigger_params("trigger_delete")
        {:ok, trigger} = Client.trigger_create(endpoint, params)
        assert :ok = Client.trigger_delete(endpoint, trigger.id)

        {:ok, triggers} = Client.trigger_index(endpoint)
        refute Enum.member?(triggers, trigger)
      end
    end
  end
end
