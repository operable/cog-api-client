defmodule CogApi.HTTP.ChatHandlesTest do
  use CogApi.HTTPCase

  alias CogApi.HTTP.Client
  import CogApi.HTTP.ResourceHelpers

  doctest CogApi.HTTP.ChatHandles

  describe "chat_handles_create" do
    it "creates a new chat handle for a user" do
      cassette "chat_handles_create" do
        endpoint = valid_endpoint
        user = find_or_create_user(endpoint, "chat_handles_create")

        handle = Client.chat_handle_upsert(
          endpoint,
          user.id,
          %{chat_provider: "slack", handle: "mpeck"}
        ) |> get_value

        assert present handle.id
        assert handle.handle == "mpeck"
        assert handle.chat_provider == "slack"
      end
    end

    it "updates the existing chat handle for a user" do
      cassette "chat_handles_update" do
        endpoint = valid_endpoint
        user = find_or_create_user(endpoint, "chat_handles_update")
        Client.chat_handle_upsert(
          endpoint,
          user.id,
          %{chat_provider: "slack", handle: "drapergeek"}
        ) |> get_value

        handle = Client.chat_handle_upsert(
          endpoint,
          user.id,
          %{chat_provider: "slack", handle: "jsteiner"}
        ) |> get_value

        chat_handles = Client.chat_handle_for_user(user.id, endpoint) |> get_value
        assert chat_handles == [handle]
      end
    end

    context "when the chat handle does not exist for the provider" do
      it "returns an error" do
        cassette "chat_handles_create_no_handle" do
          endpoint = valid_endpoint
          user = find_or_create_user(endpoint, "chat_handles_create_no_handle")

          {:error, [error]} = Client.chat_handle_upsert(
            endpoint,
            user.id,
            %{chat_provider: "slack", handle: "not_real"}
          )

          assert error == "User with handle 'not_real' not found"
        end
      end
    end
  end

  describe "chat_handles_delete" do
    it "allows deleting a chat handle" do
      cassette "chat_handles_delete" do
        endpoint = valid_endpoint
        user = find_or_create_user(endpoint, "chat_handles_delete")
        handle = Client.chat_handle_upsert(
          endpoint,
          user.id,
          %{chat_provider: "slack", handle: "christian"}
        ) |> get_value

        response = Client.chat_handle_delete(endpoint, handle.id)

        assert response == :ok
      end
    end
  end

  describe "chat_handle_for_user" do
    it "returns the user's chat handles" do
      cassette "user_chat_handles" do
        endpoint = valid_endpoint
        user = find_or_create_user(endpoint, "user_chat_handles")
        handle = Client.chat_handle_upsert(
          endpoint,
          user.id,
          %{chat_provider: "slack", handle: "mpeck"}
        ) |> get_value

        chat_handles = Client.chat_handle_for_user(user.id, endpoint) |> get_value
        assert chat_handles == [handle]
      end
    end
  end
end
