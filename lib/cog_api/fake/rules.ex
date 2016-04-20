defmodule CogApi.Fake.Rules do
  import CogApi.Fake.Helpers
  import CogApi.Fake.Random

  alias CogApi.Endpoint
  alias CogApi.Fake.Server
  alias CogApi.Resources.Rule

  def index(_, %Endpoint{token: nil}),  do: Endpoint.invalid_endpoint
  def index(command, %Endpoint{}) do
    rules =
    Server.index(Rule)
    |> Enum.filter(fn rule -> rule.command == command end)
    {:ok, rules}
  end

  def create(_, %Endpoint{token: nil}), do: Endpoint.invalid_endpoint
  def create(rule, %Endpoint{token: _}) do
    catch_errors %Rule{}, %{rule: rule}, fn ->
      new_rule = %Rule{
        command: extract_command(rule),
        id: random_string(8),
        rule: rule,
      }
      {:ok, Server.create(Rule, new_rule)}
    end
  end

  def delete(_, %Endpoint{token: nil}), do: Endpoint.invalid_endpoint
  def delete(id, %Endpoint{token: _}) do
    if Server.show(Rule, id) do
      Server.delete(Rule, id)
    else
      {:error, ["The rule could not be deleted"]}
    end
  end

  defp extract_command(rule) do
    command_pattern = ~r/\w*:\w*/
    Regex.run(command_pattern, rule)  |> List.first
  end
end
