defmodule CogApi.Fake.Helpers do
  def return_error(error) do
    {:error, [error]}
  end

  def catch_errors(struct, params, fun) do
    keys_to_verify = Map.keys struct

    errors = Map.take(params, keys_to_verify)
    |> find_errors

    if Enum.any?(errors) do
      {:error, errors}
    else
      fun.()
    end
  end

  defp find_errors(params) do
    Enum.filter_map params,
      fn {_, value} -> includes_error_string?(value) end,
      fn {key, _} ->
        key = key
        |> Atom.to_string
        |> String.replace("_", " ")
        |> String.capitalize

        "#{key} is invalid"
    end
  end

  defp includes_error_string?(string) do
    is_binary(string) && String.contains?(string, "ERROR")
  end
end
