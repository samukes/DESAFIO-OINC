defmodule DesafioOinc.Studies.Commands.DeleteStudent do
  @derive Jason.Encoder
  defstruct [:uuid]

  use ExConstructor
end
