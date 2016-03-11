defmodule CogApi.Fake.Authentication do
  alias CogApi.Endpoint

  def get_and_merge_token(%Endpoint{}=endpoint), do: endpoint
end
