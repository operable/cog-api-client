defmodule CogApi.TestHelpers do

  def present(nil),
    do: false
  def present(list) when is_list(list),
    do: true
  def present(string),
    do: String.length(string) > 1

  def get_value({:ok, value}), do: value
  def get_value({:error, errors}) do
    raise "Expected {:ok, value} and got {:error, error} - `#{errors}`"
  end
  def get_value(nil), do: raise "Expected :ok but got `nil`"
end
