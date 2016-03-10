defmodule CogApi.Fake.Random do
  def random_string(digits) do
    random_number
    |> to_string
    |> String.slice(2, digits)
  end

  defp random_number do
    :random.uniform
  end
end
