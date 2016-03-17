defmodule CogApi.TestHelpers do
  def present(string) do
    String.length(string) > 1
  end

  def get_value({:ok, value}), do: value
end
