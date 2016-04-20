defmodule CogApi.HTTP.ApiResponse do
  alias HTTPotion.Response

  @no_content 204

  defmacrop http_error?(status_code) do
    quote do
      unquote(status_code) > 399
    end
  end

  def format(response, struct_map \\ nil)

  def format({:error, error_message}, _) do
    format_error(error_message)
  end

  def format(%Response{status_code: @no_content}, _), do: :ok
  def format(%Response{status_code: code}=response, _) when http_error?(code) do
    format_error(response)
  end

  def format(response = %Response{}, struct_map) when is_nil(struct_map) do
    {
      type(response),
      Poison.decode!(response.body)
    }
  end

  def format(response = %Response{}, struct_map) do
    {
      type(response),
      parse_struct(response, struct_map)
    }
  end

  def format_delete(%Response{status_code: @no_content}, _) do
    :ok
  end

  def format_delete(%Response{}, error_message) do
    {:error, [error_message]}
  end
  def format_delete({:error, server_error}, error_message) do
    {:error, [error_message <> ": " <> server_error]}
  end

  def parse_struct(response, struct= %{__struct__: _}) do
    Poison.decode!(response.body, as: struct)
  end

  def parse_struct(response, struct_map) do
    resource = struct_map |> Map.keys |> List.first
    Poison.decode!(response.body, as: struct_map)[resource]
  end

  def format_error(response=%Response{}) do
    errors = response.body
    |> Poison.decode!
    |> extract_errors
    |> parse_errors

    {:error, errors}
  end
  def format_error(error_message) do
    {
      :error,
      parse_errors(error_message)
    }
  end

  defp extract_errors(%{"errors" => errors}), do: errors
  defp extract_errors(%{"error" => error}), do: [error]

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

  def type(%HTTPotion.Response{} = response) do
    if HTTPotion.Response.success?(response) do
      :ok
    else
      :error
    end
  end

  def type(responses) do
    if Enum.all?(responses, fn(response) -> response == :ok end) do
      :ok
    else
      :error
    end
  end
end
