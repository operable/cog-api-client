defmodule CogApi.Fake.Roles do
  import CogApi.Fake.Random

  alias CogApi.Endpoint
  alias CogApi.Fake.Server
  alias CogApi.Resources.Role

  def role_create(%Endpoint{}, %{"name" => name}) do
    new_role = %Role{id: random_string(8), name: name}
    {:ok, Server.role_create(new_role)}
  end

  def role_index(%Endpoint{}) do
    {:ok, Server.role_index}
  end
end
