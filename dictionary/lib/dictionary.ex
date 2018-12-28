defmodule Dictionary do

  alias Dictionary.WordList

  defdelegate start, to: WordList
  defdelegate random_word(words), to: WordList

end
