defmodule KeyValue.RegistryTest do
  use ExUnit.Case, async: true

  doctest KeyValue.Registry

  setup do
    registry = start_supervised!(KeyValue.Registry)
    %{registry: registry}
  end

  test "spawn buckets", %{registry: registry} do
    assert KeyValue.Registry.lookup(registry, "shopping") == :error

    KeyValue.Registry.create(registry, "shopping")
    assert {:ok, bucket} = KeyValue.Registry.lookup(registry, "shopping")

    KeyValue.Bucket.put(bucket, "milk", 1)
    assert KeyValue.Bucket.get(bucket, "milk") == 1
  end

  test "removes buckets on exit", %{registry: registry} do
    KeyValue.Registry.create(registry, "shopping")
    {:ok, bucket} = KeyValue.Registry.lookup(registry, "shopping")
    Agent.stop(bucket)
    assert KeyValue.Registry.lookup(registry, "shopping") == :error
  end

  test "removes bucket on crash", %{registry: registry} do
    KeyValue.Registry.create(registry, "shopping")
    {:ok, bucket} = KeyValue.Registry.lookup(registry, "shopping")

    # Stop the bucket with non-normal reason
    Agent.stop(bucket, :shutdown)
    assert KeyValue.Registry.lookup(registry, "shopping") == :error
  end


end
