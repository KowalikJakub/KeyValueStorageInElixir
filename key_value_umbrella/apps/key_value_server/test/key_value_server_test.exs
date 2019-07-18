defmodule KeyValueServerTest do
  use ExUnit.Case
  doctest KeyValueServer

  test "greets the world" do
    assert KeyValueServer.hello() == :world
  end
end
