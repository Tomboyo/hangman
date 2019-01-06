defmodule Dictionary.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    Supervisor.start_link(
      [
        worker(Dictionary.WordList, [])
      ], [
        name: Dictionary.Supervisor,
        strategy: :one_for_one
      ])
  end

end
