defmodule TextClient.Player do

  alias TextClient.{ Mover, Prompter, State, Summary }

  def play(game = %State{ tally: %{ state: :win }}) do
    exit_with_message(game, "You win!")
  end

  def play(game = %State{ tally: %{ state: :lose }}) do
    exit_with_message(game, "Sorry, you lose.")
  end

  def play(game = %State{ tally: %{ state: :already_guessed }}) do
    continue_with_message(game, "You have already guessed that!")
  end

  def play(game = %State{ tally: %{ state: :good_guess }}) do
    continue_with_message(game, "Good guess. That was in the word.")
  end

  def play(game = %State{ tally: %{ state: :bad_guess }}) do
    continue_with_message(game, "Sorry, that guess isn't in the word.")
  end

  def play(game = %State{ tally: %{ state: :initializing }}) do
    continue_with_message(game, "\n--- HANGMAN! ---\n")
  end

  defp exit_with_message(game, message) do
    Summary.display(game)
    IO.puts(message)
    exit(:normal)
  end

  defp continue_with_message(game, message) do
    IO.puts(message)
    continue(game)
  end

  defp continue(game) do
    game
    |> Summary.display()
    |> Prompter.accept_move()
    |> Mover.make_move()
    |> play()
  end

end
