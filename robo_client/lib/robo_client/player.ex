defmodule RoboClient.Player do

  alias TextClient.Summary
  alias RoboClient.{ Guesser, Mover, State }

  def play(game = %State{ tally: %{ state: :win }}) do
    Summary.display(game)
    exit_with_message("THE MACHINE IS VICTORIOUS.")
  end

  def play(game = %State{ tally: %{ state: :lose }}) do
    Summary.display(game)
    exit_with_message("THE GAME IS RIGGED.")
  end

  def play(game = %State{ tally: %{ state: state }})
  when state in [:initializing, :good_guess, :bad_guess, :already_guessed] do
    game
    |> Summary.display()
    |> Guesser.make_guess()
    |> Mover.make_move()
    |> play()
  end

  defp exit_with_message(message) do
    IO.puts(message)
    exit(:normal)
  end
end
