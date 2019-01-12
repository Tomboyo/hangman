defmodule Hangman.Game do

  @type state ::
      :initializing
    | :win
    | :lose
    | :good_guess
    | :bad_guess
    | :already_guessed

  @opaque t :: %__MODULE__{
    turns_left: integer,
    state:      state,
    letters:    [ String.t ],
    guessed:    MapSet.t(String.t)
  }

  @type tally :: %{
    turns_left: integer,
    state:      state,
    letters:    [ String.t ],
    guessed:    [ String.t ]
  }

  defstruct(
    turns_left: 7,
    state:      :initializing,
    letters:    [],
    guessed:    MapSet.new()
  )

  @spec new_game(String.t) :: t
  def new_game(word) do
    %Hangman.Game{
      letters: String.codepoints(word)
    }
  end

  @spec make_move(t, String.t) :: { t, tally }
  def make_move(game, guess)

  def make_move(game = %{ state: state }, _guess)
  when state in [ :win, :lose ] do
    add_tally(game)
  end

  def make_move(game, guess) do
    advance_state(game, guess)
      |> update_guessed(guess)
      |> add_tally()
  end

  defp advance_state(game, guess) do
    cond do
      # order matters; e.g. winning move is a type of good move!
      already_guessed?(game, guess) -> already_guessed(game)
      winning_guess?(game, guess)   -> win(game, guess)
      losing_guess?(game, guess)    -> lose(game, guess)
      good_guess?(game, guess)      -> good_guess(game, guess)
      bad_guess?(game, guess)       -> bad_guess(game, guess)
    end
  end

  defp already_guessed?(game, guess) do
    MapSet.member?(game.guessed, guess)
  end

  defp winning_guess?(game, guess) do
    good_guess?(game, guess) &&
      game.letters
        |> MapSet.new()
        |> MapSet.subset?(MapSet.put(game.guessed, guess))
  end

  defp losing_guess?(game, guess) do
    bad_guess?(game, guess) &&
      game.turns_left == 1
  end

  defp good_guess?(game, guess), do: Enum.member?(game.letters, guess)

  defp bad_guess?(game, guess), do: !good_guess?(game, guess)

  defp already_guessed(game) do
    %{ game | state: :already_guessed }
  end

  defp win(game, _guess) do
    %{ game | state: :win }
  end

  defp lose(game, _guess) do
    %{ game | state: :lose, turns_left: 0 }
  end

  defp good_guess(game, _guess) do
    %{ game | state: :good_guess }
  end

  defp bad_guess(game, _guess) do
    %{ game |
      state: :bad_guess,
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

  @spec tally(t) :: tally
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
