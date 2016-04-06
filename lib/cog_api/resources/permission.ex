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

  def fake_server_information do
    %{
      key: :permissions,
      associations: [
      ]
    }
  end

  def full_name(%{name: name, namespace: namespace}) do
    namespace <> ":" <> name
  end
end
