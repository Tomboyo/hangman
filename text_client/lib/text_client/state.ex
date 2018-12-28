defmodule TextClient.State do
  defstruct(
    game_service: nil,
    tally:        nil,
    guess:        ""
  )

  def new(game) do
    %TextClient.State{
      game_service: game,
      tally:        Hangman.tally(game),
      guess:        ""
    }
  end

end
