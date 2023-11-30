defmodule DesafioOinc.Studies.Commands.RestoreLecturer do
  @derive Jason.Encoder
  defstruct [:uuid]

  use ExConstructor
end
