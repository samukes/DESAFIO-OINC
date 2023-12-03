defmodule DesafioOinc.Studies.Events.LecturerAgeUpdated do
  @derive Jason.Encoder
  defstruct [:uuid, :age]

  use ExConstructor
end
