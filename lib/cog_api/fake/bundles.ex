defmodule CogApi.Fake.Bundles do
  import CogApi.Fake.Helpers
  import CogApi.Fake.Random

  alias CogApi.Endpoint
  alias CogApi.Fake.Server
  alias CogApi.Fake.Rules
  alias CogApi.Resources.Bundle

  def index(%Endpoint{token: nil}),  do: Endpoint.invalid_endpoint
  def index(%Endpoint{}) do
    {:ok, Server.index(Bundle)}
  end

  def show(%Endpoint{token: nil}, _),  do: Endpoint.invalid_endpoint
  def show(%Endpoint{}=endpoint, id) do
    bundle = Server.show(Bundle, id)
    bundle = %{bundle | commands: add_rules(endpoint, bundle)}
    {:ok, bundle}
  end

  defp add_rules(endpoint, bundle) do
    bundle.commands
    |> Enum.map(fn ({command, _}) ->
                     %{name: command, rules: find_rules(endpoint, bundle, command)}
                   (%CogApi.Resources.Command{}=command) ->
                     %{command | rules: find_rules(endpoint, bundle, command.name)}
    end)
  end

  defp find_rules(endpoint, bundle, command) do
    full_command_name = "#{bundle.name}:#{command}"
    {:ok, rules} = Rules.index(full_command_name, endpoint)
    rules
  end

  def create(%Endpoint{token: nil}, %{name: _}), do: Endpoint.invalid_endpoint
  def create(%Endpoint{token: _}, params) do
    if Enum.all?([:name, :version, :commands], &(&1 in Map.keys(params))) do
      new_bundle = %Bundle{id: random_string(8)}
      new_bundle = Map.merge(new_bundle, params)
      {:ok, Server.create(Bundle, new_bundle)}
    else
      {:error, "Invalid bundle config"}
    end
  end

  def update(%Endpoint{token: _}, %{name: name}, %{enabled: enabled} = params) do
    catch_errors params, fn ->
      current_bundle = Server.show_by_key(Bundle, :name, name)
      updated_bundle = %{current_bundle | enabled: ensure_bundle_encode_status(enabled)}
      {:ok, Server.update(Bundle, current_bundle.id, updated_bundle)}
    end
  end
  def update(%Endpoint{token: _}, id, %{enabled: enabled} = params) do
    catch_errors params, fn ->
      current_bundle = Server.show(Bundle, id)
      updated_bundle = %{current_bundle | enabled: ensure_bundle_encode_status(enabled)}

      {:ok, Server.update(Bundle, id, updated_bundle)}
    end
  end

  def update(%Endpoint{token: _}, _, %{}) do
    {:error, "You can only enable or disable a bundle"}
  end

  def delete(%Endpoint{token: nil}, _), do: Endpoint.invalid_endpoint
  def delete(%Endpoint{token: _}, id) do
    if Server.show(Bundle, id) do
      Server.delete(Bundle, id)
      :ok
    else
      {:error, ["The bundle could not be deleted"]}
    end
  end

  defp ensure_bundle_encode_status(status) do
    Bundle.encode_status(status)
    status == "true"
  end
end
