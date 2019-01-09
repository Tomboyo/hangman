defmodule Hangman.Server do

  use GenServer
  alias Hangman.Game

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(args) do
    args
    |> Keyword.get_lazy(:word, &Dictionary.random_word/0)
    |> Game.new_game()
    |> ok()
  end

  defp ok(game), do: { :ok, game }

  def handle_call({ :make_move, guess }, _from, game) do
    { game, tally } = Game.make_move(game, guess)
    { :reply, tally, game }
  end

  def handle_call({ :tally }, _from, game) do
    { :reply, Game.tally(game), game }
  end

end
