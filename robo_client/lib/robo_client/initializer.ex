defmodule RoboClient.Initializer do

  alias RoboClient.{ Player, State }

  def start() do
    { :ok, server } = Hangman.new_game()
    server
      |> State.new()
      |> Player.play()
  end

end
