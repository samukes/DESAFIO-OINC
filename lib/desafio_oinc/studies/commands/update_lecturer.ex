defmodule DesafioOinc.Studies.Commands.UpdateLecturer do
  @derive Jason.Encoder
  defstruct [:uuid, :name, :age]

  use ExConstructor
end
