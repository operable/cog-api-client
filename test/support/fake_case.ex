defmodule CogApi.FakeCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use ExSpec, async: true

      alias CogApi.Endpoint

      import CogHelper

      setup do
        CogApi.Fake.Server.start_link
        :ok
      end
    end
  end
end
