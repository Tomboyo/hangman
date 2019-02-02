defmodule Hangman.Application do
  use Application

  def start(_type, _args) do
    Supervisor.start_link(
      [ Hangman.DynamicSupervisor ],
      name: Hangman.Supervisor,
      strategy: :one_for_one
    )
  end

end
