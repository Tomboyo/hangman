defmodule Hangman do

  alias Hangman.DynamicSupervisor
  alias Hangman.Game

  @doc """
  Start a new game of hangman.

  The following keyword list options are supported:
    - word: A secret word string. If provided, this will be the secret word that
      the player must guess. If missing, a random word is selected instead.
  """
  @spec new_game(keyword) :: GenServer.on_start
  def new_game(args \\ []) do
    DynamicSupervisor.start_child(args)
  end

  @doc """
  Guess a letter in a game of hangman.
  """
  @spec make_move(GenServer.server, String.t) :: { Game.tally }
  def make_move(server, guess) do
    GenServer.call(server, { :make_move, guess })
  end

  @doc """
  Get the current state of a game of hangman.
  """
  @spec tally(GenServer.server) :: { Game.tally }
  def tally(server) do
    GenServer.call(server, { :tally })
  end

end
