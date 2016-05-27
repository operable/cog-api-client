defmodule CogApi.Resources.BundleVersion do
  @derive [Poison.Encoder]

  alias CogApi.Resources.Permission
  alias CogApi.Resources.Command

  defstruct [
    :id,
    :version,
    :name,
    :bundle_id,
    :enabled,
    :inserted_at,
    permissions: [%Permission{}],
    commands: [%Command{}]
  ]
end

defimpl Poison.Decoder, for: CogApi.Resources.BundleVersion do
  def decode(value, _options) do
    default(value, :perms)
    |> default(:commands)
  end

  defp default(%{permissions: [%{id: nil}]}=value, :perms),
    do: %{value | permissions: []}
  defp default(%{commands: [%{name: nil}]}=value, :commands),
    do: %{value | commands: []}
  defp default(value, _),
    do: value
end
