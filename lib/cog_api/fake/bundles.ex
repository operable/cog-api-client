defmodule CogApi.Fake.Bundles do
  import CogApi.Fake.Helpers
  import CogApi.Fake.Random

  alias CogApi.Endpoint
  alias CogApi.Fake.Server
  alias CogApi.Fake.Rules
  alias CogApi.Resources.Bundle
  alias CogApi.Resources.Command

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
    |> Enum.map(fn(command) ->
         %{command | rules: find_rules(endpoint, bundle, command.name)}
       end)
  end

  defp find_rules(endpoint, bundle, command) do
    full_command_name = "#{bundle.name}:#{command}"
    {:ok, rules} = Rules.index(full_command_name, endpoint)
    rules
  end

  def create(%Endpoint{token: nil}, %{name: _}), do: Endpoint.invalid_endpoint
  def create(endpoint=%Endpoint{token: _}, params) do
    params = to_atom_keys(params)
    if Enum.all?([:name, :version, :commands], &(&1 in Map.keys(params))) do
      commands = parse_commands(params[:commands], endpoint)
      new_bundle = %Bundle{id: random_string(8)}
      new_bundle = Map.merge(new_bundle, %{params | commands: commands})
      new_bundle = Server.create(Bundle, new_bundle)
      show(endpoint, new_bundle.id)
    else
      {:error, ["Invalid bundle config"]}
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

  defp to_atom_keys(map) do
    Enum.reduce(map, %{}, fn ({key, val}, acc) ->
      if is_map(val) do
        val = to_atom_keys(val)
      end

      if is_atom(key) do
        Map.put(acc, key, val)
      else
        Map.put(acc, String.to_atom(key), val)
      end
    end)
  end

  defp parse_commands(commands, endpoint) do
    commands
    |> Enum.map(fn command -> parse_command(command, endpoint) end)
  end

  defp parse_command(%Command{}=command, _), do: command
  defp parse_command({name, command}, endpoint) do
    create_rules(command.rules, endpoint)

    Map.merge(%Command{}, command)
    |> Map.merge(%{name: name})
  end

  defp create_rules(rules, endpoint) do
    Enum.map(rules, fn (rule) ->
      {:ok, rule} = CogApi.Fake.Rules.create(rule, endpoint)
      rule
    end)
  end
end
