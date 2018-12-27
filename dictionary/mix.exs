defmodule Dictionary.MixProject do
  use Mix.Project

  def project do
    [
      app: :dictionary,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: dependencies()
    ]
  end

  def application do
    [ ]
  end

  defp dependencies do
    [ ]
  end
end
