defmodule CogApi.HTTP.Rules do
  alias CogApi.HTTP.ApiResponse
  alias CogApi.HTTP.Base

  alias CogApi.Endpoint
  alias CogApi.Resources.Rule

  def index(command, %Endpoint{}=endpoint) do
    Base.get(endpoint, "rules?for-command=#{command}")
    |> ApiResponse.format(%{"rules" => [%Rule{}]})
  end

  def create(rule_text, %Endpoint{}=endpoint) do
    Base.post(endpoint, "rules", %{rule: rule_text})
    |> ApiResponse.format(%Rule{})
  end

  def delete(rule_id, %Endpoint{}=endpoint) do
    Base.delete(endpoint, "rules/#{rule_id}")
    |> ApiResponse.format_delete("The rule could not be deleted")
  end
end
