defmodule Hangman.Server do

  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_args) do
    { :ok, Hangman.new_game() }
  end

  def handle_call({ :make_move, guess }, _from, game) do
    { game, tally } = Hangman.make_move(game, guess)
    { :reply, tally, game }
  end

end
