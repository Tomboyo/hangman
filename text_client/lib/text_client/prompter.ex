defmodule TextClient.Prompter do

  def accept_move(game) do
    IO.gets("Your guess: ")
    |> validate_input(game)
  end

  defp validate_input({ :error, reason }, _game) do
    IO.puts("Encountered error: #{reason}")
    exit(:normal)
  end

  defp validate_input(:eof, _game) do
    IO.puts("Come back later!")
    exit(:normal)
  end

  defp validate_input(input, game) do
    input = String.trim(input)
    if input =~ ~r/\A[a-z]\z/ do
      %{ game | guess: input }
    else
      IO.puts("Please enter a lowercase character.")
      accept_move(game)
    end
  end

end
