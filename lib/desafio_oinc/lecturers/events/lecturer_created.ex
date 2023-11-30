defmodule DesafioOinc.Lecturers.Events.LecturerCreated do
  @derive Jason.Encoder
  defstruct [:uuid, :name, :age]
end
