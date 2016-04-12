defmodule CogApi.Resources.Trigger do
  @derive [Poison.Encoder]

  defstruct [:id,
             :name,
             :pipeline,
             :as_user,
             :timeout_sec,
             :description,
             :invocation_url]

  def format,
    do: %__MODULE__{}

  def fake_key,
    do: :triggers

  def associations,
    do: []

end
