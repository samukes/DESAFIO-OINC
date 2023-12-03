defmodule DesafioOinc.Studies.Commands.RestoreStudent do
  @derive Jason.Encoder
  defstruct [:uuid]

  use ExConstructor
end
