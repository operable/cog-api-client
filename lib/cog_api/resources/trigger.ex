defmodule CogApi.Resources.Trigger do
  @derive [Poison.Encoder]

  defstruct [:id,
             :name,
             :pipeline,
             :as_user,
             :description,
             :invocation_url,
             enabled: true,
             timeout_sec: 30]

  def format,
    do: %__MODULE__{}

  def fake_key,
    do: :triggers

  def associations,
    do: []

end
