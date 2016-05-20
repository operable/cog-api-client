defmodule CogApi.Resources.Permission do
  @derive [Poison.Encoder]

  defstruct [
    :id,
    :name,
    :bundle,
  ]

  def format do
    %__MODULE__{
    }
  end

  def fake_key do
    :permissions
  end

  def associations do
    []
  end

  def full_name(%{name: name, bundle: bundle}) do
    bundle <> ":" <> name
  end
end
