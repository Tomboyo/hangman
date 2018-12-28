defmodule RoboClient.Mover do

  alias RoboClient.State

  def make_move(%State{ game_service: gs, guess: guess }) do
    { gs, tally } = Hangman.make_move(gs, guess)
    %State{
      game_service: gs,
      tally:        tally
    }
  end

end
