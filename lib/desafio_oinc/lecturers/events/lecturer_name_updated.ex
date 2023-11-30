defmodule DesafioOinc.Lecturers.Events.LecturerNameUpdated do
  @derive Jason.Encoder
  defstruct [:uuid, :name]

  use ExConstructor
end
