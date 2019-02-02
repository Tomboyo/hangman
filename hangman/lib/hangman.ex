defmodule Hangman do

  alias Hangman.DynamicSupervisor
  alias Hangman.Game

  @spec new_game(keyword) :: GenServer.on_start
  def new_game(args \\ []) do
    DynamicSupervisor.start_child(args)
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
