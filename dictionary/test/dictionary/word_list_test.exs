defmodule Dictionary.WordListTest do
  @moduledoc """
  Tests the Dictionary.WordList implementation module.

  These tests rely on per-test supervised agents in order to isolate behavior
  from other tests at runtime.
  """

  use ExUnit.Case
  alias Dictionary.WordList

  describe "Dictionary" do
    setup do
      pid =
        WordList.child_spec([[name: Dictionary.WordListTest]])
        |> start_supervised!()
      [ pid: pid ]
    end

    test "random_word returns a nonempty string", context do
      actual = WordList.random_word(context[:pid])
      assert String.length(actual) > 0
    end
  end
end
