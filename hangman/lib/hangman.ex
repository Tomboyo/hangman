defmodule Hangman do

  alias Hangman.Server

  def new_game() do
    Server.start_link([])
  end

  def new_game(args) when is_list(args) do
    Server.start_link(args)
  end

  def make_move(server, guess) do
    GenServer.call(server, { :make_move, guess })
  end

  def tally(server) do
    GenServer.call(server, { :tally })
  end

end
