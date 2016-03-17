defmodule CogApi.Test.FakeHelpers do
  alias CogApi.Endpoint

  def fake_endpoint do
    {:ok, endpoint} = %Endpoint{} |> CogApi.Fake.Client.authenticate
    endpoint
  end
end
