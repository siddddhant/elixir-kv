defmodule KV.BucketTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, bucket} = KV.Bucket.start_link([])
    %{bucket: bucket}
  end

  test "stores value by key", %{bucket: bucket} do
    assert KV.Bucket.get(bucket, :milk) == nil

    KV.Bucket.put(bucket, :milk, 1)
    assert KV.Bucket.get(bucket, :milk) == 1
  end

  test "deletes value by key and returns it", %{bucket: bucket} do
    KV.Bucket.put(bucket, :milk, 1)
    assert KV.Bucket.delete(bucket, :milk) == 1
    assert KV.Bucket.get(bucket, :milk) == nil

    assert KV.Bucket.delete(bucket, :milk) == nil
  end

  test "buckets are temporary workers" do
    assert Supervisor.child_spec(KV.Bucket, []).restart == :temporary
  end
end
