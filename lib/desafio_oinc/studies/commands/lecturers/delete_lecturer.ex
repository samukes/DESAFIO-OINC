defmodule DesafioOinc.Studies.Commands.DeleteLecturer do
  @derive Jason.Encoder
  defstruct [:uuid]

  use ExConstructor
end
