defmodule Hangman.Application do
  use Application

  def start(_type, _args) do
    Supervisor.start_link(
      [ Hangman.Server ],
      name: Hangman.Supervisor,
      strategy: :simple_one_for_one
    )
  end

end
