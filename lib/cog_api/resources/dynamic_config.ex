defmodule CogApi.Resources.DynamicConfig do
  @derive [Poison.Encoder]

  defstruct [
    :bundle_id,
    :bundle_name,
    :config,
    :inserted_at,
  ]

  def format do
    %__MODULE__{}
  end

  def fake_key do
    :dynamic_config
  end

  def associations do
    []
  end
end
