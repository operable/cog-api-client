defmodule CogApi.HTTP.Rules do
  alias HTTPotion.Response

  alias CogApi.HTTP.ApiResponse
  alias CogApi.HTTP.Base

  alias CogApi.Endpoint
  alias CogApi.Resources.Rule

  def index(command, %Endpoint{}=endpoint) do
    Base.get(endpoint, "rules?for-command=#{command}")
    |> format_index_response
  end

  def create(bundle_version_id, rule_text, %Endpoint{}=endpoint) do
    Base.post(endpoint, "bundle_versions/#{bundle_version_id}/rules", %{rule: rule_text})
    |> ApiResponse.format(%Rule{})
  end

  def show(rule_id, %Endpoint{}=endpoint) do
    Base.get(endpoint, "rules/#{rule_id}")
    |> ApiResponse.format(%Rule{})
  end

  def update(rule_id, rule_text, %Endpoint{}=endpoint) do
    Base.patch(endpoint, "rules/#{rule_id}", %{rule: rule_text})
    |> ApiResponse.format(%Rule{})
  end

  def update(bundle_version_id, rule_id, rule_text, %Endpoint{}=endpoint) do
    Base.patch(endpoint, "bundle_versions/#{bundle_version_id}/rules/#{rule_id}", %{rule: rule_text})
    |> ApiResponse.format(%Rule{})
  end

  def delete(rule_id, %Endpoint{}=endpoint) do
    Base.delete(endpoint, "rules/#{rule_id}")
    |> ApiResponse.format_delete("The rule could not be deleted")
  end

  def delete(bundle_version_id, rule_id, %Endpoint{}=endpoint) do
    Base.delete(endpoint, "bundle_versions/#{bundle_version_id}/rules/#{rule_id}")
    |> ApiResponse.format_delete("The rule could not be deleted")
  end

  def format_index_response(%Response{status_code: 422}) do
    {:ok, []}
  end

  def format_index_response(response) do
    ApiResponse.format(response, %{"rules" => [%Rule{}]})
  end
end
