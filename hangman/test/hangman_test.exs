defmodule HangmanTest do
  use ExUnit.Case

  test "Hangman.new_game returns a structure" do
    game = Hangman.new_game

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
    assert Enum.empty?(game.guessed)
  end

  test "state is unchanged for a :won or :lost game regardless of guess" do
    for state <- [:win, :lose],
        guess <- ~w(c x) do
      { game, _tally } =
        %{ Hangman.new_game("cactus") | game_state: state }
        |> Hangman.make_move(guess)
      assert %{ game_state: ^state, turns_left: 7 } = game
    end
  end

  test "first occurrence of a guess is not :already_used" do
    { game, _tally } = Hangman.new_game
    |> Hangman.make_move("a")

    assert game.game_state != :already_guessed
  end

  test "duplicate occurrence of a guess is :already_used" do
    {game, _} = Enum.reduce(
      ~w(a a),
      {Hangman.new_game("abc"), nil},
      fn guess, {acc, _} -> Hangman.make_move(acc, guess) end)

    assert %{game_state: :already_guessed} = game
  end

  test "guessed is updated on a guess" do
    guess = "a"
    { game, _tally } = Hangman.new_game
    |> Hangman.make_move(guess)

    assert MapSet.member?(game.guessed, guess)
  end

  test "a good guess is recognized" do
    { game, _tally } =
      Hangman.new_game("word")
      |> Hangman.make_move("w")
    assert %{ game_state: :good_guess } = game
  end

  test "a winning guess is recongized" do
    { game, _tally } = Hangman.new_game("aaa")
    |> Hangman.make_move("a")

    assert %{ game_state: :win } = game
  end

  test "a bad guess is recognized" do
    { game, _tally } = Hangman.new_game("a")
    |> Hangman.make_move("b")

    assert %{ game_state: :bad_guess } = game
  end

  test "a bad guess decrements remaining turns" do
    { game, _tally } = Hangman.new_game("a")
    |> Hangman.make_move("b")

    assert %{ turns_left: 6 } = game
  end

  test "a losing guess is recongized" do
    { game, _tally } = Enum.reduce(
      ~w(b c d e f g h),
      {Hangman.new_game("a"), %{}},
      fn guess, {acc, _} -> Hangman.make_move(acc, guess) end)

    assert %{ turns_left: 0, game_state: :lose } = game
  end
end
