defmodule DictionaryTest do
  use ExUnit.Case

  test "random_word returns a nonempty string" do
    actual =
      Dictionary.start()
      |> Dictionary.random_word()
      |> String.length()
    assert actual > 0
  end
end
