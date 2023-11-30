defmodule DesafioOinc.Lecturers.Events.LecturerRestored do
  @derive Jason.Encoder
  defstruct [:uuid]

  use ExConstructor
end
