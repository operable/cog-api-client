defmodule CogApi.Resources.Bundle do
  @derive [Poison.Encoder]

  alias CogApi.Resources.RelayGroup
  alias CogApi.Resources.BundleVersion

  defstruct [
    :id,
    :inserted_at,
    :name,
    :updated_at,
    :modifiable,
    enabled_version: %BundleVersion{},
    versions: [%BundleVersion{}],
    relay_groups: [%RelayGroup{}],
  ]

  # This is left here because of the whole decoder thing. When we convert
  # everything to just use poison decoders we should be able to drop it.
  def format do
    %__MODULE__{
      enabled_version: %BundleVersion{},
      versions: [%BundleVersion{}],
      relay_groups: [%RelayGroup{}],
    }
  end
end

defimpl Poison.Decoder, for: CogApi.Resources.Bundle do
  def decode(value, _options) do
    set_modifiable(value)
    |> default(:perms)
    |> default(:groups)
    |> default(:enabled_version)
  end

  # The "operable" bundle is the only non-modifiable bundle.
  defp set_modifiable(%{name: "operable"}=value),
    do: %{value | modifiable: false}
  defp set_modifiable(value),
    do: %{value | modifiable: true}

  # Poison requires us to define an empty struct as the default
  # value for nested structs. This is how it determines how those
  # nested values should be decoded. However, if we get back nothing
  # for a nested item, we end up with the default blank struct as
  # the items value. This is not the desired behavior. So instead,
  # if we run across neste items with nil ids, we can just replace
  # those with a more appropriate default value
  defp default(%{permissions: [%{id: nil}]}=value, :perms),
    do: %{value | permissions: []}
  defp default(%{relay_groups: [%{id: nil}]}=value, :groups),
    do: %{value | relay_groups: []}
  defp default(%{enabled_version: %{id: nil}}=value, :enabled_version),
    do: %{value | enabled_version: nil}
  defp default(value, _),
    do: value
end
