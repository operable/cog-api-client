defmodule CogApi.Fake.Helpers do
  def catch_errors(params, fun) do
    errors = find_errors(params)

    if Enum.any?(errors) do
      {:error, errors}
    else
      fun.()
    end
  end

  defp find_errors(params) do
    Enum.filter_map params,
      fn {_, value} -> value == "ERROR" end,
      fn {key, _} ->
        key = key
        |> Atom.to_string
        |> String.replace("_", " ")
        |> String.capitalize

        "#{key} is invalid"
    end
  end
end
