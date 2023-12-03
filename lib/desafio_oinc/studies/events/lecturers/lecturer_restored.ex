defmodule DesafioOinc.Studies.Events.LecturerRestored do
  @derive Jason.Encoder
  defstruct [:uuid]

  use ExConstructor
end
