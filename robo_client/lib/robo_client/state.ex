defmodule RoboClient.State do

  defstruct(
    game_service: nil,
    tally:        nil,
    guess:        nil
  )

  def new(game_service) do
    %RoboClient.State{
      game_service: game_service,
      tally:        Hangman.tally(game_service)
    }
  end

end
