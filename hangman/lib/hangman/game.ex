defmodule Hangman.Game do

  defstruct(
    turns_left: 7,
    state:      :initializing,
    letters:    [],
    guessed:    MapSet.new()
  )

  def new_game(), do: new_game(Dictionary.random_word)
  def new_game(word) do
    %Hangman.Game{
      letters: String.codepoints(word)
    }
  end

  def tally(game) do
    %{
      state: game.state,
      turns_left: game.turns_left,
      letters: Enum.map(game.letters, fn x -> reveal(x, game.guessed) end)
    }
  end

  defp reveal(letter, guessed) do
    if MapSet.member?(guessed, letter)
    do letter
    else "_"
    end
  end

  def make_move(game = %{state: state}, _guess)
  when state in [:win, :lose] do
    game
  end

  def make_move(game, guess) do
    cond do
      # order matters; e.g. winning move is a type of good move!
      erroneous_move?(game, guess) -> erroneous_move(game, guess)
      winning_move?(game, guess)   -> win(game, guess)
      losing_move?(game, guess)    -> lose(game, guess)
      good_move?(game, guess)      -> good_play(game, guess)
      bad_move?(game, guess)       -> bad_play(game, guess)
    end
  end

  defp erroneous_move?(game, guess), do: MapSet.member?(game.guessed, guess)
  defp winning_move?(game, guess) do
    good_move?(game, guess) &&
      game.letters
        |> MapSet.new()
        |> MapSet.subset?(MapSet.put(game.guessed, guess))
  end
  defp losing_move?(game, guess) do
    bad_move?(game, guess) &&
      game.turns_left == 1
  end
  defp good_move?(game, guess), do: Enum.member?(game.letters, guess)
  defp bad_move?(game, guess), do: !good_move?(game, guess)

  defp erroneous_move(game, _guess) do
    %{ game | state: :already_guessed }
  end

  defp win(game, guess) do
    %{ game |
      state: :win,
      guessed: MapSet.put(game.guessed, guess)
    }
  end

  defp lose(game, guess) do
    %{ game |
      state: :lose,
      guessed: MapSet.put(game.guessed, guess),
      turns_left: 0
    }
  end

  defp good_play(game, guess) do
    %{ game |
      state: :good_play,
      guessed: MapSet.put(game.guessed, guess),
    }
  end

  defp bad_play(game, guess) do
    %{ game |
      state: :bad_play,
      guessed: MapSet.put(game.guessed, guess),
      turns_left: game.turns_left - 1
    }
  end
end
