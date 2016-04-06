defmodule CogApi.Resources.Permission do
  @derive [Poison.Encoder]

  defstruct [
    :id,
    :name,
    :namespace,
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

  def full_name(%{name: name, namespace: namespace}) do
    namespace <> ":" <> name
  end
end
