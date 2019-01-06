defmodule Dictionary.WordList do

  @name __MODULE__

  def child_spec(args) do
    %{
      id: Keyword.get(args, :name, @name),
      start: { __MODULE__, :start_link, args }
    }
  end

  def start_link(args \\ []) do
    Agent.start_link(&word_list/0, name: Keyword.get(args, :name, @name))
  end

  defp word_list() do
    "../../assets/words.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.split(~r/\n/)
  end

  def random_word(name \\ @name) do
    Agent.get(name, &Enum.random/1)
  end

end
