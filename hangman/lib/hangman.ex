defmodule Hangman do

  alias Hangman.Server
  alias Hangman.Game

  def new_game() do
    Supervisor.start_child(Hangman.Supervisor, [])
  end

  @spec new_game(keyword) :: GenServer.on_start
  def new_game(args) do
    Server.start_link(args)
  end

  @spec make_move(GenServer.server, String.t) :: { Game.tally }
  def make_move(server, guess) do
    GenServer.call(server, { :make_move, guess })
  end

  @spec tally(GenServer.server) :: { Game.tally }
  def tally(server) do
    GenServer.call(server, { :tally })
  end

end
