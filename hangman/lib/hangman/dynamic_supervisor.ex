defmodule Hangman.DynamicSupervisor do

  use DynamicSupervisor

  @name __MODULE__

  def start_link(options \\ []) do
    DynamicSupervisor.start_link(__MODULE__, options, name: @name)
  end

  @impl true
  def init(_options) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_child(args \\ []) do
    DynamicSupervisor.start_child(
      @name,
      { Hangman.Server, args }
    )
  end
end
