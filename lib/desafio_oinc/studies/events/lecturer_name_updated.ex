defmodule DesafioOinc.Studies.Events.LecturerNameUpdated do
  @derive Jason.Encoder
  defstruct [:uuid, :name]

  use ExConstructor
end
