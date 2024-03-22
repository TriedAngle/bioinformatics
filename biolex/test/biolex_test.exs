defmodule BiolexTest do
  use ExUnit.Case
  doctest Biolex

  test "greets the world" do
    assert Biolex.hello() == :world
  end
end
