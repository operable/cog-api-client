defmodule CogApi.Decoders.Helpers do
  def decode_many(resources, module) do
    Enum.map(resources, &module.to_resource/1)
  end
end
