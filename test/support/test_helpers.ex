defmodule CogApi.TestHelpers do

  def present(nil),
    do: false
  def present(list) when is_list(list),
    do: true
  def present(string),
    do: String.length(string) > 1

  def get_value({:ok, value}), do: value
  def get_value({:error, errors}) do
    raise "Expected {:ok, value} and got {:error, error} - `#{inspect errors}`"
  end
  def get_value(nil), do: raise "Expected :ok but got `nil`"

  def bundle_config(params \\ %{}) do
    name = params[:name] || "bundle"
    Map.merge(bundle_config_with_name(name), Map.delete(params, :name))
  end

  def bundle_config_with_name(name \\ "bundle") do
    %{
      name: name,
      cog_bundle_version: 2,
      version: "0.0.1",
      permissions: [
        "#{name}:permission",
      ],
      commands: %{
        test_command: %{
          documentation: "Does a thing",
          executable: "/foo/bar",
          rules: ["when command is #{name}:test_command must have #{name}:permission"]
        }
      }
    }
  end
end
