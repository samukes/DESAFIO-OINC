defmodule DesafioOinc.Lecturers.Commands.CreateLecturer do
  @derive Jason.Encoder
  defstruct [:uuid, :name, :age, deleted_at: nil]

  use ExConstructor
end
