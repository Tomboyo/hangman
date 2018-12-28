defmodule RoboClient.Guesser do

  alias RoboClient.State

  def make_guess(game = %State{}) do
    %{ game | guess: guess_letter() }
  end

  defp guess_letter() do
    "abcdefghijklmnopqrstuvwxyz"
    |> String.codepoints()
    |> Enum.random()
  end

end
