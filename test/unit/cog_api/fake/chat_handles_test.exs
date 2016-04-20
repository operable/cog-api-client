defmodule CogApi.Fake.ChatHandlesTest do
  use CogApi.FakeCase

  import CogApi.Fake.ResourceHelpers
  alias CogApi.Fake.Client

  doctest CogApi.Fake.ChatHandles

  describe "chat_handles_create" do
    it "allows creating a new chat handle for a user" do
      endpoint = valid_endpoint
      user = find_or_create_user(endpoint, "chat_handles_create")

      handle = Client.chat_handle_create(
        endpoint,
        user.id,
        %{chat_provider: "slack", handle: "mpeck"}
      ) |> get_value

      assert present handle.id
      assert handle.handle == "mpeck"
      assert handle.chat_provider == "slack"
    end

    context "when the chat handle does not exist for the provider" do
      it "returns an error" do
        endpoint = valid_endpoint
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
      endpoint = valid_endpoint
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

  describe "chat_handle_for_user" do
    it "returns the user's chat handles" do
      params = %{
        first_name: "Leo",
        last_name: "McGary",
        email_address: "cos@example.com",
        username: "chief_of_staff",
        password: "supersecret",
      }
      user = Client.user_create(valid_endpoint, params) |> get_value
      handle = Client.chat_handle_create(
        valid_endpoint,
        user.id,
        %{chat_provider: "slack", handle: "bar"}
      ) |> get_value

      _other_handle = Client.chat_handle_create(
        valid_endpoint,
        "other-user-id",
        %{chat_provider: "slack", handle: "foo"}
      ) |> get_value

      chat_handles = Client.chat_handle_for_user(user.id, valid_endpoint) |> get_value
      assert chat_handles == [handle]
    end
  end
end
