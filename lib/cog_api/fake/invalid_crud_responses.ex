defmodule CogApi.Fake.InvalidCrudResponses do
  defmacro __using__(_opts) do
    quote do
      alias CogApi.Endpoint
      @invalid_token "INVALID"

      def index(%Endpoint{token: nil}) do
        Endpoint.invalid_endpoint
      end
      def index(%Endpoint{token: @invalid_token}) do
        invalid_token
      end

      def show(%Endpoint{token: nil}, _) do
        Endpoint.invalid_endpoint
      end
      def show(%Endpoint{token: @invalid_token}, _) do
        invalid_token
      end

      def create(%Endpoint{token: nil}, _) do
        Endpoint.invalid_endpoint
      end
      def create(%Endpoint{token: @invalid_token}, _) do
        invalid_token
      end

      def update(%Endpoint{token: nil}, _, _) do
        Endpoint.invalid_endpoint
      end
      def update(%Endpoint{token: @invalid_token}, _, _) do
        invalid_token
      end

      def delete(%Endpoint{token: nil}, _) do
        Endpoint.invalid_endpoint
      end
      def delete(%Endpoint{token: @invalid_token}, _) do
        invalid_token
      end

      defp invalid_token do
        {:authentication_error, ["User cannot be authenticated"]}
      end
    end
  end
end
