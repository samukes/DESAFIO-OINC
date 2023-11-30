defmodule DesafioOinc.Lecturers.Commands.DeleteLecturer do
  @derive Jason.Encoder
  defstruct [:uuid]

  use ExConstructor
end
