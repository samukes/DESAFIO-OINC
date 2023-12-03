defmodule DesafioOinc.Studies.Commands.RestoreLesson do
  @derive Jason.Encoder
  defstruct [:uuid]

  use ExConstructor
end
