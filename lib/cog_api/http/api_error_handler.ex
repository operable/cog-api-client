defmodule CogApi.HTTP.ApiErrorHandler do
  alias HTTPotion.Response
  @unauthorized 401
  @internal_server_error 500

  def format_error_list(response=%Response{}) do
    response.body
    |> decode_json
    |> extract_errors
    |> parse_errors
  end

  def decode_json(body) do
    case Poison.decode(body) do
      {:ok, decoded} -> decoded
      {:error, _} -> nil
    end
  end

  def format_error(%Response{status_code: @internal_server_error}) do
    {:error, ["Internal server error"]}
  end
  def format_error(response=%Response{}) do
    {error_key(response), format_error_list(response)}
  end
  def format_error(error_message) do
    {
      :error,
      parse_errors(error_message)
    }
  end

  def error_key(%Response{status_code: @unauthorized}) do
    :authentication_error
  end

  def error_key(%Response{status_code: _code}) do
    :error
  end

  defp extract_errors(%{"errors" => errors}), do: errors
  defp extract_errors(%{"error" => error}), do: [error]
  defp extract_errors(error), do: [error]

  defp parse_errors(errors = %{}) do
    Enum.flat_map errors, fn {key, values} ->
      key = String.replace(key, "_", " ") |> String.capitalize

      Enum.map(values, &format_error(key, &1))
    end
  end
  defp parse_errors(errors) when is_list(errors), do: errors
  defp parse_errors(errors) when is_binary(errors) do
    [errors]
  end


  defp format_error(key, {error_key, value}) do
    "#{key} #{error_key} - #{Enum.join(value, "")}"
  end

  defp format_error(key, value) do
    "#{key} #{value}"
  end
end
