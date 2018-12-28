defmodule RoboClient.Initializer do

  alias RoboClient.{ Player, State }

  def start() do
    Hangman.new_game()
    |> State.new()
    |> Player.play()
  end

end
