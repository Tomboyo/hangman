defmodule RoboClient do

  alias RoboClient.Initializer

  defdelegate start(), to: Initializer

end
