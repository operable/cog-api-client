defmodule CogApi.Resources.BundleVersion do
  @derive [Poison.Encoder]

  alias CogApi.Resources.Permission
  alias CogApi.Resources.Command

  defstruct [
    :id,
    :version,
    :name,
    :description,
    :bundle_id,
    :enabled,
    :incompatible,
    :status,
    :inserted_at,
    :config_file,
    permissions: [%Permission{}],
    commands: [%Command{}]
  ]
end

defimpl Poison.Decoder, for: CogApi.Resources.BundleVersion do
  def decode(value, _options) do
    default(value, :perms)
    |> default(:commands)
    |> set_status()
  end

  defp default(%{permissions: [%{id: nil}]}=value, :perms),
    do: %{value | permissions: []}
  defp default(%{commands: [%{name: nil}]}=value, :commands),
    do: %{value | commands: []}
  defp default(value, _),
    do: value

  defp set_status(%{incompatible: true}=version),
    do: %{version | status: "Incompatible"}
  defp set_status(%{enabled: true}=version),
    do: %{version | status: "Enabled"}
  defp set_status(%{enabled: false}=version),
    do: %{version | status: "Disabled"}
  defp set_status(version),
    do: %{version | status: nil}

end
