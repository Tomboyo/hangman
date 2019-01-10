defmodule HangmanTest do
  use ExUnit.Case

  test "Hangman.new_game returns { :ok, server }" do
    { :ok, server } = Hangman.new_game
    assert is_pid(server)
  end

  describe "A new game tally" do
    setup do
      { :ok, server } = Hangman.new_game(word: "word")
      tally = Hangman.tally(server)

      [ tally: tally ]
    end

    test "has no guessed letters", %{ tally: tally } do
      assert tally.guessed == []
    end

    test "reveals no letters in the word", %{ tally: tally } do
      assert tally.letters == ~w(_ _ _ _)
    end

    test "has turns left", %{ tally: tally } do
      assert tally.turns_left > 0
    end

    test "is :initializing", %{ tally: tally } do
      assert tally.state == :initializing
    end
  end

  describe "A game in play" do
    setup do
      { :ok, server } = Hangman.new_game(word: "word")
      [ server: server ]
    end

    test "a duplicate guess is :already_guessed", %{ server: server } do
      Hangman.make_move(server, "x")
      tally = Hangman.make_move(server, "x")

      assert tally.state == :already_guessed
    end

    test "previous guesses are tracked", %{ server: server } do
      tally = Hangman.make_move(server, "x")

      assert tally.guessed == [ "x" ]
    end

    test "a :good_guess is recognized", %{ server: server } do
      tally = Hangman.make_move(server, "w")

      assert tally.state == :good_guess
    end

    test "a :bad_guess is recognized", %{ server: server } do
      tally = Hangman.make_move(server, "x")

      assert tally.state == :bad_guess
    end

    test "a :win is recognized", %{ server: server } do
      ~w(w o r d)
        |> Enum.each(&Hangman.make_move(server, &1))
      tally = Hangman.tally(server)

      assert tally.state == :win
    end

    test "a :bad_guess uses up a turn", %{ server: server } do
      initial_turns = Hangman.tally(server).turns_left
      remaining_turns = Hangman.make_move(server, "x").turns_left

      assert remaining_turns == initial_turns - 1
    end
  end

  describe "a lost game" do
    setup do
      { :ok, server } = Hangman.new_game(word: "word")

      ~w(a b c e f g h)
        |> Enum.each(fn guess -> Hangman.make_move(server, guess) end)

      [ tally: Hangman.tally(server), server: server ]
    end

    test "is in the :lose state", %{ tally: tally } do
      assert tally.state == :lose
    end

    test "has no turns remaining", %{ tally: tally } do
      assert tally.turns_left == 0
    end

    test "ignores additional moves", %{ server: server, tally: tally } do
      actual = Hangman.make_move(server, "x")

      assert actual == tally
    end

    test "has every letter revealed", %{ tally: tally } do
      assert tally.letters == ~w(w o r d)
    end
  end

  describe "a won game" do
    setup do
      { :ok, server } = Hangman.new_game(word: "word")

      ~w(w o r d)
        |> Enum.each(fn guess -> Hangman.make_move(server, guess) end)

      [ tally: Hangman.tally(server), server: server ]
    end

    test "is in the :win state", %{ tally: tally } do
      assert tally.state == :win
    end

    test "has at least one turn left", %{ tally: tally } do
      assert tally.turns_left > 0
    end

    test "ignores additional moves", %{ server: server, tally: tally } do
      actual = Hangman.make_move(server, "x")

      assert actual == tally
    end

    test "has every letter guessed", %{ tally: tally } do
      guessed = MapSet.new(tally.guessed)
      word = MapSet.new(~w(w o r d))
      assert MapSet.subset?(word, guessed)
    end

    test "has every letter revealed", %{ tally: tally } do
      assert tally.letters == ~w(w o r d)
    end
  end
end
