defmodule Hangman.Game do

  defstruct(
    turns_left: 7,
    state:      :initializing,
    letters:    [],
    guessed:    MapSet.new()
  )

  def new_game() do
    Dictionary.random_word()
    |> new_game()
  end

  def new_game(word) do
    %Hangman.Game{
      letters: String.codepoints(word)
    }
  end

  def make_move(game, guess) do
    advance_state(game, guess)
    |> update_guessed(guess)
    |> add_tally()
  end

  defp advance_state(game = %{state: state}, _guess)
  when state in [:win, :lose] do
    game
  end

  defp advance_state(game, guess) do
    cond do
      # order matters; e.g. winning move is a type of good move!
      erroneous_play?(game, guess) -> erroneous_play(game, guess)
      winning_play?(game, guess)   -> win(game, guess)
      losing_play?(game, guess)    -> lose(game, guess)
      good_play?(game, guess)      -> good_play(game, guess)
      bad_play?(game, guess)       -> bad_play(game, guess)
    end
  end

  defp erroneous_play?(game, guess), do: MapSet.member?(game.guessed, guess)

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

  defp erroneous_play(game, _guess) do
    %{ game | state: :already_guessed }
  end

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

  defp update_guessed(game, guess) do
    Map.update!(game, :guessed, fn guessed ->
      MapSet.put(guessed, guess) end
    )
  end

  defp add_tally(game) do
    { game, tally(game) }
  end

  defp tally(game) do
    %{
      state: game.state,
      turns_left: game.turns_left,
      guessed: MapSet.to_list(game.guessed),
      letters: Enum.map(game.letters, fn x -> reveal(x, game.guessed) end)
    }
  end

  defp reveal(letter, guessed) do
    if MapSet.member?(guessed, letter)
    do letter
    else "_"
    end
  end
end
