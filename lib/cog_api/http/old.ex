defmodule CogApi.HTTP.Old do
  alias CogApi.Endpoint

  def get(%Endpoint{}=endpoint, resource, params \\ %{}) do
    rescue_econnrefused(fn ->
      response = HTTPotion.get(make_url(endpoint, resource, params), headers: make_headers(endpoint))
      {response_type(response), Poison.decode!(response.body)}
    end)
  end

  def post(%Endpoint{}=endpoint, resource, params) do
    rescue_econnrefused(fn ->
      body = Poison.encode!(params)
      response = HTTPotion.post(make_url(endpoint, resource), body: body, headers: make_headers(endpoint, ["Content-Type": "application/json"]))
      {response_type(response), Poison.decode!(response.body)}
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

  def find_id_by(endpoint, resource, find_fun)
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

  def find_id_by(endpoint, resource, [{param_key, param_value}]) do
    find_id_by(endpoint, resource, fn item ->
      item[to_string(param_key)] == param_value
    end)
  end

  def bootstrap_show(%Endpoint{}=endpoint) do
    get(endpoint, "bootstrap")
  end

  def bootstrap_create(%Endpoint{}=endpoint) do
    post(endpoint, "bootstrap", [])
  end

  def bundle_show(%Endpoint{}=endpoint, bundle_name) do
    get_by(endpoint, "bundles", name: bundle_name)
  end

  def bundle_delete(%Endpoint{}=endpoint, bundle_name) do
    delete_by(endpoint, "bundles", name: bundle_name)
  end

  def bundle_status(%Endpoint{}=endpoint, bundle_name, status) do
    with {:ok, bundle_id} <- find_id_by(endpoint, "bundles", name: bundle_name) do
      post(endpoint, "bundles/#{bundle_id}/status", %{status: status})
    end
  end

  def bundle_enable(%Endpoint{}=endpoint, bundle_name) do
    bundle_status(endpoint, bundle_name, "enabled")
  end

  def bundle_disable(%Endpoint{}=endpoint, bundle_name) do
    bundle_status(endpoint, bundle_name, "disabled")
  end

  def user_show(%Endpoint{}=endpoint, user_username) do
    get_by(endpoint, "users", username: user_username)
  end

  def user_update(%Endpoint{}=endpoint, user_username, params) do
    patch_by(endpoint, "users", [username: user_username], params)
  end

  def user_delete(%Endpoint{}=endpoint, user_username) do
    delete_by(endpoint, "users", username: user_username)
  end

  def group_show(%Endpoint{}=endpoint, group_name) do
    with {:ok, group_id} <- find_id_by(endpoint, "groups", name: group_name),
      {:ok, group} <- get(endpoint, "groups/#{URI.encode(group_id)}"),
      {:ok, members} <- get(endpoint, "groups/#{URI.encode(group_id)}/memberships"),
      do: {:ok, Map.update!(group, "group", &Map.merge(&1, members))}
  end

  def group_update(%Endpoint{}=endpoint, group_name, params) do
    patch_by(endpoint, "groups", [name: group_name], params)
  end

  def group_delete(%Endpoint{}=endpoint, group_name) do
    delete_by(endpoint, "groups", name: group_name)
  end

  def group_add(%Endpoint{}=endpoint, group_name, type, item_to_add)
      when type in [:users, :groups] do
    with {:ok, group_id} <- find_id_by(endpoint, "groups", name: group_name),
      {:ok, group} <- get(endpoint, "groups/#{URI.encode(group_id)}"),
      {:ok, _} <- post(endpoint, "groups/#{URI.encode(group_id)}/membership", %{members: Map.put(%{}, type, %{add: [item_to_add]})}),
      {:ok, members} <- get(endpoint, "groups/#{URI.encode(group_id)}/memberships"),
      do: {:ok, Map.update!(group, "group", &Map.merge(&1, members))}
  end

  def group_remove(%Endpoint{}=endpoint, group_name, type, item_to_remove)
      when type in [:users, :groups] do
    with {:ok, group_id} <- find_id_by(endpoint, "groups", name: group_name),
      {:ok, group} <- get(endpoint, "groups/#{URI.encode(group_id)}"),
      {:ok, _} <- post(endpoint, "groups/#{URI.encode(group_id)}/membership", %{members: Map.put(%{}, type, %{remove: [item_to_remove]})}),
      {:ok, members} <- get(endpoint, "groups/#{URI.encode(group_id)}/memberships"),
      do: {:ok, Map.update!(group, "group", &Map.merge(&1, members))}
  end

  def role_update(%Endpoint{}=endpoint, role_name, params) do
    patch_by(endpoint, "roles", [name: role_name], params)
  end

  def role_delete(%Endpoint{}=endpoint, role_name) do
    delete_by(endpoint, "roles", name: role_name)
  end

  def role_grant(%Endpoint{}=endpoint, role_name, type, item_to_grant)
      when type in ["users", "groups"] do
    result = case type do
      "users" ->
        find_id_by(endpoint, type, username: item_to_grant)
      "groups" ->
        find_id_by(endpoint, type, name: item_to_grant)
    end

    with {:ok, id} <- result do
      post(endpoint, "#{type}/#{URI.encode(id)}/roles", %{roles: %{grant: [role_name]}})
    end
  end

  def role_revoke(%Endpoint{}=endpoint, role_name, type, item_to_revoke)
      when type in ["users", "groups"] do
    result = case type do
      "users" ->
        find_id_by(endpoint, type, username: item_to_revoke)
      "groups" ->
        find_id_by(endpoint, type, name: item_to_revoke)
    end

    with {:ok, id} <- result do
      post(endpoint, "#{type}/#{URI.encode(id)}/roles", %{roles: %{revoke: [role_name]}})
    end
  end

  def permission_index(endpoint, params \\ %{})

  def permission_index(%Endpoint{}=endpoint, %{user: user_username}) do
    with {:ok, user_id} <- find_id_by(endpoint, "users", username: user_username) do
      get(endpoint, "users/#{user_id}/permissions")
    end
  end

  def permission_index(%Endpoint{}=endpoint, %{group: group_name}) do
    with {:ok, group_id} <- find_id_by(endpoint, "groups", name: group_name) do
      get(endpoint, "groups/#{group_id}/permissions")
    end
  end

  def permission_index(%Endpoint{}=endpoint, %{role: role_name}) do
    with {:ok, role_id} <- find_id_by(endpoint, "roles", name: role_name) do
      get(endpoint, "roles/#{role_id}/permissions")
    end
  end

  def permission_delete(%Endpoint{}=endpoint, name) do
    delete_by(endpoint, "permissions", fn item ->
      item["name"] == name &&
        item["namespace"]["name"] == "site"
    end)
  end

  def permission_grant(%Endpoint{}=endpoint, permission_name, type, item_to_grant)
      when type in ["users", "roles", "groups"] do
    result = case type do
      "users" ->
        find_id_by(endpoint, type, username: item_to_grant)
      type when type in ["roles", "groups"] ->
        find_id_by(endpoint, type, name: item_to_grant)
    end

    with {:ok, id} <- result do
      post(endpoint, "#{type}/#{URI.encode(id)}/permissions", %{permissions: %{grant: [permission_name]}})
    end
  end

  def permission_revoke(%Endpoint{}=endpoint, permission_name, type, item_to_revoke)
      when type in ["users", "roles", "groups"] do
    result = case type do
      "users" ->
        find_id_by(endpoint, type, username: item_to_revoke)
      type when type in ["roles", "groups"] ->
        find_id_by(endpoint, type, name: item_to_revoke)
    end

    with {:ok, id} <- result do
      post(endpoint, "#{type}/#{URI.encode(id)}/permissions", %{permissions: %{revoke: [permission_name]}})
    end
  end

  def rule_index(%Endpoint{}=endpoint, command) do
    get(endpoint, "rules?for-command=" <> URI.encode(command))
  end

  def rule_create(%Endpoint{}=endpoint, params) do
    post(endpoint, "rules", params)
  end

  def rule_delete(%Endpoint{}=endpoint, rule_id) do
    delete(endpoint, "rules" <> "/" <> URI.encode(rule_id))
  end

  def chat_handle_index(%Endpoint{}=endpoint) do
    get(endpoint, "chat_handles")
  end

  def chat_handle_create(%Endpoint{}=endpoint, %{chat_handle: %{user: user}} = params) do
    with {:ok, user_id} <- find_id_by(endpoint, "users", username: user) do
      post(endpoint, "users/#{user_id}/chat_handles", params)
    end
  end

  def chat_handle_delete(%Endpoint{}=endpoint, %{chat_handle: %{user: user, chat_provider: chat_provider}}) do
    delete_by(endpoint, "chat_handles", fn item ->
      item["user"]["username"] == user &&
        item["chat_provider"]["name"] == chat_provider
    end)
  end

  defp rescue_econnrefused(fun) do
    try do
      fun.()
    rescue
      HTTPotion.HTTPError ->
        {:error, %{"error" => "An instance of cog must be running"}}
    end
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

    if map_size(params) == 0 do
      url
    else
      URI.encode(url <> "?" <> URI.encode_query(params))
    end
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
