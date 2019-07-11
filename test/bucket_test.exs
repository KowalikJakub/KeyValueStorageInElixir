defmodule KeyValue.BucketTest do
  use ExUnit.Case, async: true
  doctest KeyValue.Bucket

  setup do
    bucket = start_supervised!(KeyValue.Bucket)
    %{bucket: bucket}
  end

  test "stores values by key", %{bucket: bucket} do
    assert KeyValue.Bucket.get(bucket, "milk") == nil

    KeyValue.Bucket.put(bucket, "milk", 3)
    assert KeyValue.Bucket.get(bucket, "milk") == 3
  end
end
