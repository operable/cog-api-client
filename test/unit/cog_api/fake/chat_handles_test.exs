defmodule CogApi.Fake.ChatHandlesTest do
  use CogApi.FakeCase

  import CogApi.Fake.ResourceHelpers
  alias CogApi.Fake.Client

  doctest CogApi.Fake.ChatHandles

  describe "chat_handles_create" do
    it "allows creating a new chat handle for a user" do
      endpoint = fake_endpoint
      user = find_or_create_user(endpoint, "chat_handles_create")

      handle = Client.chat_handle_create(
        endpoint,
        user.id,
        %{chat_provider: "slack", handle: "mpeck"}
      ) |> get_value

      assert present handle.id
      assert handle.handle == "mpeck"
    end

    context "when the chat handle does not exist for the provider" do
      it "returns an error" do
        endpoint = fake_endpoint
        user = find_or_create_user(endpoint, "chat_handles_create_no_handle")

        {:error, [error]} = Client.chat_handle_create(
          endpoint,
          user.id,
          %{chat_provider: "slack", handle: "ERROR"}
        )

        assert error == "Handle is invalid"
      end
    end
  end

  describe "chat_handles_delete" do
    it "allows deleting a chat handle" do
      endpoint = fake_endpoint
      user = find_or_create_user(endpoint, "chat_handles_delete")
      handle = Client.chat_handle_create(
        endpoint,
        user.id,
        %{chat_provider: "slack", handle: "christian"}
      ) |> get_value

      response = Client.chat_handle_delete(endpoint, handle.id)

      assert response == :ok
    end
  end
end
