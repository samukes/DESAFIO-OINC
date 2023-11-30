defmodule DesafioOinc.Lecturers.Commands.UpdateLecturer do
  @derive Jason.Encoder
  defstruct [:uuid, :name, :age]

  use ExConstructor
end
