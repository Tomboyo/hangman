defmodule TextClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :textclient,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      { :hangman, path: "../hangman" }
    ]
  end
end
