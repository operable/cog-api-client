defmodule CogApi.HTTP.Base do
  alias CogApi.Endpoint

  def get(%Endpoint{}=endpoint, resource, params \\ %{}) do
    rescue_econnrefused(fn ->
      HTTPotion.get(
        make_url(endpoint, resource, params),
        headers: make_headers(endpoint)
      )
    end)
  end

  def post(%Endpoint{}=endpoint, resource, params) do
    rescue_econnrefused(fn ->
      body = Poison.encode!(params)
      HTTPotion.post(make_url(endpoint, resource), body: body, headers: make_headers(endpoint))
    end)
  end

  def patch(%Endpoint{}=endpoint, resource, params) do
    rescue_econnrefused(fn ->
      body = Poison.encode!(params)
      HTTPotion.patch(make_url(endpoint, resource), body: body, headers: make_headers(endpoint))
    end)
  end

  def put(%Endpoint{}=endpoint, resource, params) do
    rescue_econnrefused(fn ->
      body = Poison.encode!(params)
      HTTPotion.put(make_url(endpoint, resource), body: body, headers: make_headers(endpoint))
    end)
  end

  def delete(%Endpoint{}=endpoint, resource) do
    rescue_econnrefused(fn ->
      HTTPotion.delete(make_url(endpoint, resource), headers: make_headers(endpoint))
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
    with {:ok, items} <- get(endpoint, resource)
        |> CogApi.HTTP.ApiResponse.format(%{resource => %{}}) do
      case Enum.find(items, find_fun) do
        %{"id" => id} ->
          {:ok, id}
        nil ->
          {:error, "Resource not found for: '#{resource}'"}
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
        {:error, "Could not connect to a Cog instance"}
    end
  end

  defp make_url(%Endpoint{proto: proto, host: host, port: port,
                            version: version}, route, params \\ %{}) do
    route = if is_function(route) do
      route.()
    else
      URI.encode(route)
    end
    url = "#{proto}://#{host}:#{port}/v#{version}"
    url = if String.starts_with?(route, "/") do
      "#{url}#{route}"
    else
      "#{url}/#{route}"
    end

    format_params(url, params)
  end

  def format_params(url, params) when map_size(params) == 0,  do: url
  def format_params(url, params) do
    URI.encode(url <> "?" <> URI.encode_query(params))
  end

  @default_headers ["Accept": "application/json", "Content-Type": "application/json"]

  defp make_headers(%Endpoint{token: nil}) do
    @default_headers
  end
  defp make_headers(%Endpoint{token: token}) do
    ["authorization": "token " <> token] ++ @default_headers
  end

  def response_type(%HTTPotion.Response{} = response) do
    if HTTPotion.Response.success?(response) do
      :ok
    else
      :error
    end
  end

  def response_type(responses) do
    if Enum.all?(responses, fn(response) -> response == :ok end) do
      :ok
    else
      :error
    end
  end
end
