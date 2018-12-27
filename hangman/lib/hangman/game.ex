defmodule Hangman.Game do

  defstruct(
    turns_left: 7,
    state: :initializing,
    letters:    [],
    guessed:    MapSet.new()
  )

  def new_game(), do: new_game(Dictionary.random_word)
  def new_game(word) do
    %Hangman.Game{
      letters: String.codepoints(word)
    }
  end

  def make_move(game = %{state: state}, _guess)
  when state in [:win, :lose] do
    game
  end

  def make_move(game, guess) do
    if   MapSet.member?(game.guessed, guess)
    do   make_repeat_move(game)
    else make_original_move(game, guess)
    end
  end

  defp make_repeat_move(game) do
    %{ game | state: :already_guessed }
  end

  defp make_original_move(game, guess) do
    game = %{ game | guessed: MapSet.put(game.guessed, guess) }

    if Enum.member?(game.letters, guess)
    do make_good_guess(game)
    else make_bad_guess(game)
    end
  end

  defp make_good_guess(game) do
    if MapSet.new(game.letters)
       |> MapSet.subset?(game.guessed)
    do %{ game | state: :win }
    else %{ game | state: :good_guess }
    end
  end

  defp make_bad_guess(game = %{ turns_left: 1 }) do
    %{ game |
      state: :lose,
      turns_left: 0
    }
  end
  defp make_bad_guess(game = %{ turns_left: turns }) do
    %{ game |
      state: :bad_guess,
      turns_left: turns - 1
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
end
