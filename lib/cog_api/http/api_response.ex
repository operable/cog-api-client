defmodule CogApi.HTTP.ApiResponse do
  alias HTTPotion.Response
  alias CogApi.HTTP.ApiErrorHandler

  @no_content 204
  @not_authorized 403

  defmacrop http_error?(status_code) do
    quote do
      unquote(status_code) > 399
    end
  end

  def format(response, struct_map \\ nil)

  def format({:error, error_message}, _) do
    ApiErrorHandler.format_error(error_message)
  end

  def format(%Response{status_code: @no_content}, _), do: :ok

  def format(%Response{status_code: code}=response, _) when http_error?(code) do
    ApiErrorHandler.format_error(response)
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

  def format(%Response{status_code: code}=response, _, _) when http_error?(code) do
    ApiErrorHandler.format_error(response)
  end
  def format(%Response{}=response, struct, key) do
    resource = Poison.decode!(response.body, as: %{key => struct})
    |> Map.get(key)

    {type(response), resource}
  end

  def format_many(%Response{status_code: @not_authorized}, _, _) do
    {:error, ["Not Authorized"]}
  end
  def format_many(%Response{}=response, struct, key) do
    resources = Poison.decode!(response.body, as: %{key => [struct]})
    |> Map.get(key)

    {type(response), resources}
  end

  def format_many_with_decoder({:error, error_message}, _, _) do
    ApiErrorHandler.format_error(error_message)
  end
  def format_many_with_decoder(%Response{status_code: code}=response, _, _) when
  http_error?(code) do
    ApiErrorHandler.format_error(response)
  end
  def format_many_with_decoder(response, decoder, key) do
    json_structure = %{key => [decoder.format]}
    resources = Poison.decode!(response.body, as: json_structure)[key]
    |> Enum.map(&decoder.to_resource/1)

    {
      type(response),
      resources
    }
  end

  def format_with_decoder({:error, error_message}, _, _) do
    ApiErrorHandler.format_error(error_message)
  end
  def format_with_decoder(%Response{status_code: code}=response, _, _) when
  http_error?(code) do
    ApiErrorHandler.format_error(response)
  end
  def format_with_decoder(response, decoder, key) do
    json_structure = %{key => decoder.format}
    resource = Poison.decode!(response.body, as: json_structure)[key]
    |> decoder.to_resource

    {
      type(response),
      resource
    }
  end

  def format_delete(_, error_message \\ nil)
  def format_delete(%Response{status_code: @no_content}, _) do
    :ok
  end
  def format_delete(%Response{body: body}, nil) do
    error = Poison.decode!(body)
    |> Map.get("error")

    {:error, [error]}
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
