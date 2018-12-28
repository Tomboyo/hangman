defmodule RoboClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :robo_client,
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
      { :hangman,     path: "../hangman" },
      { :text_client, path: "../text_client" }
    ]
  end
end
