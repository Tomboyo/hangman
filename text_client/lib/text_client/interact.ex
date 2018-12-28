defmodule TextClient.Interact do

  alias TextClient.{ State, Player }

  def start() do
    Hangman.new_game()
    |> State.new
    |> Player.play()
  end

end
