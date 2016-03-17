defmodule CogApi.HTTPCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use ExSpec, async: true
      use ExVCR.Mock

      alias CogApi.Endpoint

      import CogApi.TestHelpers
      import CogApi.Test.HTTPHelpers

      defmacro cassette(fixture, test) do
        quote do
          use_cassette(
            unquote(fixture),
            [match_requests_on: [:query, :request_body]],
            unquote(test)
          )
        end
      end
    end
  end
end
