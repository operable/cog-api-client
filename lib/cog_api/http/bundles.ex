defmodule CogApi.HTTP.Bundles do
  alias CogApi.HTTP.ApiResponse
  alias CogApi.HTTP.Base

  alias CogApi.Endpoint
  alias CogApi.Resources.Bundle
  alias CogApi.Resources.BundleVersion

  def index(%Endpoint{}=endpoint) do
    Base.get(endpoint, "bundles")
    |> ApiResponse.format_many(%Bundle{}, "bundles")
  end

  def version_index(%Endpoint{}=endpoint, bundle_id) do
    Base.get(endpoint, "bundles/#{bundle_id}/versions")
    |> ApiResponse.format_many(%BundleVersion{}, "bundle_versions")
  end

  def version_index_by_name(%Endpoint{}=endpoint, bundle_name) do
    with {:ok, bundles} <- index(endpoint),
         {:ok, bundle} <- find_bundle(bundles, bundle_name) do
           version_index(endpoint, bundle.id)
    end
  end

  def show(%Endpoint{}=endpoint, id) do
    Base.get(endpoint, "bundles/#{id}")
    |> ApiResponse.format(%Bundle{}, "bundle")
  end

  def show_by_name(%Endpoint{}=endpoint, bundle_name) do
    with {:ok, bundles} <- index(endpoint),
         {:ok, bundle} <- find_bundle(bundles, bundle_name) do
           show(endpoint, bundle.id)
    end
  end

  def version_show(%Endpoint{}=endpoint, bundle_id, version_id) do
    Base.get(endpoint, "bundles/#{bundle_id}/versions/#{version_id}")
    |> ApiResponse.format(%BundleVersion{}, "bundle_version")
  end

  def version_show_by_name(%Endpoint{}=endpoint, bundle_name, bundle_version) do
    with {:ok, bundles} <- index(endpoint),
         {:ok, bundle} <- find_bundle(bundles, bundle_name),
         {:ok, version} <- find_version(bundle, bundle_version) do
           version_show(endpoint, bundle.id, version.id)
    end
  end

  def install(%Endpoint{}=endpoint, params) do
    Base.post(endpoint, "bundles", %{bundle: params})
    |> ApiResponse.format(%BundleVersion{}, "bundle_version")
  end

  def install_from_registry(%Endpoint{}=endpoint, bundle_name, version) do
    Base.post(endpoint, "bundles/install/#{bundle_name}/#{version}", %{})
    |> ApiResponse.format(%BundleVersion{}, "bundle_version")
  end

  def uninstall(%Endpoint{}=endpoint, id) do
    Base.delete(endpoint, "bundles/#{id}")
    |> ApiResponse.format_delete
  end

  def uninstall_by_name(%Endpoint{}=endpoint, bundle_name) do
    with {:ok, bundles} <- index(endpoint),
         {:ok, bundle} <- find_bundle(bundles, bundle_name) do
           uninstall(endpoint, bundle.id)
    end
  end

  def uninstall_version(%Endpoint{}=endpoint, bundle_id, version_id) do
    Base.delete(endpoint, "bundles/#{bundle_id}/versions/#{version_id}")
    |> ApiResponse.format_delete
  end

  def uninstall_version_by_name(%Endpoint{}=endpoint, bundle_name, bundle_version) do
    with {:ok, bundles} <- index(endpoint),
         {:ok, bundle} <- find_bundle(bundles, bundle_name),
         {:ok, version} <- find_version(bundle, bundle_version) do
           uninstall_version(endpoint, bundle.id, version.id)
    end
  end

  def enable_version(%Endpoint{}=endpoint, bundle_id, bundle_version_id) do
    Base.post(endpoint, "bundles/#{bundle_id}/versions/#{bundle_version_id}/status", %{status: "enabled"})
    |> ApiResponse.format
  end

  def enable_version_by_name(%Endpoint{}=endpoint, bundle_name, bundle_version) do
    with {:ok, bundles} <- index(endpoint),
         {:ok, bundle} <- find_bundle(bundles, bundle_name),
         {:ok, version} <- find_version(bundle, bundle_version) do
           enable_version(endpoint, bundle.id, version.id)
    end
  end

  def enabled_version(%Endpoint{}=endpoint, bundle_id) do
    Base.get(endpoint, "bundles/#{bundle_id}/status")
    |> ApiResponse.format
  end

  def enabled_version_by_name(%Endpoint{}=endpoint, bundle_name) do
    with {:ok, bundles} <- index(endpoint),
         {:ok, bundle} <- find_bundle(bundles, bundle_name) do
           enabled_version(endpoint, bundle.id)
    end
  end

  def disable_version(%Endpoint{}=endpoint, bundle_id, bundle_version_id) do
    Base.post(endpoint, "bundles/#{bundle_id}/versions/#{bundle_version_id}/status", %{status: "disabled"})
    |> ApiResponse.format
  end

  def disable_version_by_name(%Endpoint{}=endpoint, bundle_name, bundle_version) do
    with {:ok, bundles} <- index(endpoint),
         {:ok, bundle} <- find_bundle(bundles, bundle_name),
         {:ok, version} <- find_version(bundle, bundle_version) do
           disable_version(endpoint, bundle.id, version.id)
    end
  end


  defp dynamic_config_layer_path(bundle_id, "base", nil),
    do: "bundles/#{bundle_id}/dynamic_config/base"
  defp dynamic_config_layer_path(bundle_id, layer, name),
    do: "bundles/#{bundle_id}/dynamic_config/#{layer}/#{name}"

  def create_dynamic_config(%Endpoint{}=endpoint, bundle_id, layer, name, config) do
    Base.post(endpoint, dynamic_config_layer_path(bundle_id, layer, name), %{config: config})
    |> ApiResponse.format
  end

  def delete_dynamic_config(%Endpoint{}=endpoint, bundle_id, layer, name) do
    Base.delete(endpoint, dynamic_config_layer_path(bundle_id, layer, name)) |> ApiResponse.format
  end

  def show_dynamic_config(%Endpoint{}=endpoint, bundle_id, layer, name) do
    Base.get(endpoint, dynamic_config_layer_path(bundle_id, layer, name)) |> ApiResponse.format
  end

  def dynamic_config_index(%Endpoint{}=endpoint, bundle_id) do
    Base.get(endpoint, "bundles/#{bundle_id}/dynamic_config/")
    |> ApiResponse.format_many(%CogApi.Resources.DynamicConfig{}, "dynamic_configurations")
  end

  defp find_bundle(bundles, bundle_name) do
    case Enum.find(bundles, &(&1.name == bundle_name)) do
      nil ->
        {:error, ["A bundle with the name '#{bundle_name}' could not be found."]}
      bundle ->
        {:ok, bundle}
    end
  end

  defp find_version(bundle, bundle_version) do
    case Enum.find(bundle.versions, &(&1.version == bundle_version)) do
      nil ->
        {:error, ["Version '#{bundle_version}' of '#{bundle.name}' is not installed."]}
      version ->
        {:ok, version}
    end
  end
end
