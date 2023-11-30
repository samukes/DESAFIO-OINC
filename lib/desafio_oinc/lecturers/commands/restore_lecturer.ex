defmodule DesafioOinc.Lecturers.Commands.RestoreLecturer do
  @derive Jason.Encoder
  defstruct [:uuid]

  use ExConstructor
end
