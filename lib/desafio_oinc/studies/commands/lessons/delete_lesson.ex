defmodule DesafioOinc.Studies.Commands.DeleteLesson do
  @derive Jason.Encoder
  defstruct [:uuid]

  use ExConstructor
end
