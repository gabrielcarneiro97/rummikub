defmodule RMKTest do
  use ExUnit.Case
  doctest RMK

  test "greets the world" do
    assert RMK.hello() == :world
  end
end
