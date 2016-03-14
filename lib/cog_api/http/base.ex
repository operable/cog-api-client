defmodule CogApi.HTTP.Base do
  alias CogApi.Endpoint
  alias HTTPotion.Response

  def get(%Endpoint{}=endpoint, resource, params \\ %{}) do
    rescue_econnrefused(fn ->
      response = HTTPotion.get(
        make_url(endpoint, resource, params),
        headers: make_headers(endpoint)
      )
    end)
  end

  def post(%Endpoint{}=endpoint, resource, params) do
    rescue_econnrefused(fn ->
      body = Poison.encode!(params)
      HTTPotion.post(make_url(endpoint, resource), body: body, headers: make_headers(endpoint, ["Content-Type": "application/json"]))
    end)
  end

  def patch(%Endpoint{}=endpoint, resource, params) do
    rescue_econnrefused(fn ->
      body = Poison.encode!(params)
      response = HTTPotion.patch(make_url(endpoint, resource), body: body, headers: make_headers(endpoint, ["Content-Type": "application/json"]))
      {response_type(response), Poison.decode!(response.body)}
    end)
  end

  def delete(%Endpoint{}=endpoint, resource) do
    rescue_econnrefused(fn ->
      response = HTTPotion.delete(make_url(endpoint, resource), headers: make_headers(endpoint))
      case response_type(response) do
        :ok ->
          :ok
        :error ->
          {:error, Poison.decode!(response.body)}
      end
    end)
  end

  # TODO: Replace the following with single parameterized get call once it
  # exists in the Cog API
  def get_by(%Endpoint{}=endpoint, resource, filter) do
    with {:ok, id} <- find_id_by(endpoint, resource, filter) do
      get(endpoint, resource <> "/" <> URI.encode(id))
    end
  end

  def patch_by(%Endpoint{}=endpoint, resource, filter, params) do
    with {:ok, id} <- find_id_by(endpoint, resource, filter) do
      patch(endpoint, resource <> "/" <> URI.encode(id), params)
    end
  end

  def delete_by(%Endpoint{}=endpoint, resource, filter) do
    with {:ok, id} <- find_id_by(endpoint, resource, filter) do
      delete(endpoint, resource <> "/" <> URI.encode(id))
    end
  end

  def find_id_by(%Endpoint{}=endpoint, resource, find_fun)
      when is_function(find_fun) do
    with {:ok, %{^resource => items}} <- get(endpoint, resource) do
      case Enum.find(items, find_fun) do
        %{"id" => id} ->
          {:ok, id}
        nil ->
          {:error, %{"error" => "Resource not found"}}
      end
    end
  end

  def find_id_by(%Endpoint{}=endpoint, resource, [{param_key, param_value}]) do
    find_id_by(endpoint, resource, fn item ->
      item[to_string(param_key)] == param_value
    end)
  end

  def rescue_econnrefused(fun) do
    try do
      fun.()
    rescue
      HTTPotion.HTTPError ->
        {:no_connection_error, "An instance of cog must be running"}
    end
  end

  def format_response(response = {:no_connection_error, _}), do: response
  def format_response(response = %Response{status_code: 403}) do
    format_error(response)
  end
  def format_response(response = %Response{}) do
    {
      response_type(response),
      Poison.decode!(response.body)
    }
  end
  def format_response(response = {:error, _}, _, _), do: response
  def format_response(response = %Response{}, resource, struct) do
    {
      response_type(response),
      Poison.decode!(
        response.body,
        as: %{resource => struct}
      )[resource]
    }
  end

  defp format_error(response) do
    {
      :error,
      Poison.decode!(response.body)["error"]
    }
  end

  defp make_url(%Endpoint{proto: proto, host: host, port: port,
                            version: version}, route, params \\ %{}) do
    route = if is_function(route) do
      route.()
    else
      route
    end
    url = "#{proto}://#{host}:#{port}/v#{version}"
    url = if String.starts_with?(route, "/") do
      "#{url}#{route}"
    else
      "#{url}/#{route}"
    end

    format_params(url, params)
  end

  defp format_params(url, params) when is_map params and map_size(params) == 0 do
    url
  end

  defp format_params(url, params) when is_map params do
    URI.encode(url <> "?" <> URI.encode_query(params))
  end

  defp format_params(url, params) do
    "#{url}/#{params}"
  end

  defp make_headers(endpoint, others \\ ["Accept": "application/json"])
  defp make_headers(%Endpoint{token: nil}, others) do
    others
  end
  defp make_headers(%Endpoint{token: token}, others) do
    ["authorization": "token " <> token] ++ others
  end

  defp response_type(response) do
    if HTTPotion.Response.success?(response) do
      :ok
    else
      :error
    end
  end
end
