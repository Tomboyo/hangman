defmodule DictionaryTest do
  @moduledoc """
  Tests the Dictionary API / Facade module.

  These tests rely on the supervised agent started by application.ex.
  """

  use ExUnit.Case

  test "random_word returns a nonempty string" do
    actual = Dictionary.random_word()
    assert String.length(actual) > 0
  end

end
