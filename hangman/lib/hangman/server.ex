defmodule Hangman.Server do

  use GenServer
  alias Hangman.Game

  @spec start_link(keyword) :: GenServer.on_start
  def start_link(args \\ []) do
    GenServer.start_link(__MODULE__, args)
  end

  @impl GenServer
  def init(args) do
    args
    |> Keyword.get_lazy(:word, &Dictionary.random_word/0)
    |> Game.new_game()
    |> ok()
  end

  defp ok(game), do: { :ok, game }

  @impl GenServer
  def handle_call({ :make_move, guess }, _from, game) do
    { game, tally } = Game.make_move(game, guess)
    { :reply, tally, game }
  end

  @impl GenServer
  def handle_call({ :tally }, _from, game) do
    { :reply, Game.tally(game), game }
  end

end
