defmodule Hangman.Game do

  defstruct(
    turns_left: 7,
    state:      :initializing,
    letters:    [],
    guessed:    MapSet.new()
  )

  def new_game(word) do
    %Hangman.Game{
      letters: String.codepoints(word)
    }
  end

  def make_move(game = %{ state: state }, _guess)
  when state in [ :win, :lose ] do
    add_tally(game)
  end

  def make_move(game, guess) do
    if already_guessed?(game, guess) do
      already_guessed(game)
    else
      advance_state(game, guess)
    end
      |> add_tally()
  end

  defp already_guessed?(game, guess) do
    MapSet.member?(game.guessed, guess)
  end

  defp already_guessed(game) do
    %{ game | state: :already_guessed }
  end

  defp advance_state(game, guess) do
    cond do
      # order matters; e.g. winning move is a type of good move!
      winning_play?(game, guess)   -> win(game, guess)
      losing_play?(game, guess)    -> lose(game, guess)
      good_play?(game, guess)      -> good_play(game, guess)
      bad_play?(game, guess)       -> bad_play(game, guess)
    end
      |> update_guessed(guess)
  end

  defp winning_play?(game, guess) do
    good_play?(game, guess) &&
      game.letters
        |> MapSet.new()
        |> MapSet.subset?(MapSet.put(game.guessed, guess))
  end

  defp losing_play?(game, guess) do
    bad_play?(game, guess) &&
      game.turns_left == 1
  end

  defp good_play?(game, guess), do: Enum.member?(game.letters, guess)

  defp bad_play?(game, guess), do: !good_play?(game, guess)

  defp win(game, _guess) do
    %{ game | state: :win }
  end

  defp lose(game, _guess) do
    %{ game | state: :lose, turns_left: 0 }
  end

  defp good_play(game, _guess) do
    %{ game | state: :good_play }
  end

  defp bad_play(game, _guess) do
    %{ game |
      state: :bad_play,
      turns_left: game.turns_left - 1
    }
  end

  defp update_guessed(game = %{ state: state }, guess)
  when state != :already_guessed do
    Map.update!(game, :guessed, fn guessed ->
      MapSet.put(guessed, guess) end
    )
  end

  defp update_guessed(game, _guess) do
    game
  end

  defp add_tally(game) do
    { game, tally(game) }
  end

  def tally(game) do
    %{
      state: game.state,
      turns_left: game.turns_left,
      guessed: MapSet.to_list(game.guessed),
      letters: reveal_letters(game)
    }
  end

  defp reveal_letters(game = %{ state: state })
  when state == :lose do
    game.letters
  end

  defp reveal_letters(%{ letters: letters, guessed: guessed }) do
    Enum.map(letters, fn letter -> reveal(letter, guessed) end)
  end

  defp reveal(letter, guessed) do
    if MapSet.member?(guessed, letter)
    do letter
    else "_"
    end
  end
end
