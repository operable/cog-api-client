defmodule CogApi.Fake.Random do
  @on_load :seed_random

  def random_string(digits) do
    random_number
    |> to_string
    |> String.slice(2, digits)
  end

  def seed_random do
    :random.seed({
      :crypto.rand_uniform(1, 99999),
      :crypto.rand_uniform(1, 99999),
      :crypto.rand_uniform(1, 99999)
    })

    :ok
  end

  defp random_number do
    :random.uniform
  end
end
