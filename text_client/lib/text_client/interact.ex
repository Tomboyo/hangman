defmodule TextClient.Interact do

  alias TextClient.{ State, Player }

  def start() do
    { :ok, server } = Hangman.new_game()
    server
    |> State.new
    |> Player.play()
  end

end
