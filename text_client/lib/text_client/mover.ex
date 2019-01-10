defmodule TextClient.Mover do

  alias TextClient.State

  def make_move(%{ game_service: gs, guess: guess }) do
    %State{
      game_service: gs,
      tally:        Hangman.make_move(gs, guess)
    }
  end

end
