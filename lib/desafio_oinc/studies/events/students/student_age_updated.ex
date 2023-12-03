defmodule DesafioOinc.Studies.Events.StudentAgeUpdated do
  @derive Jason.Encoder
  defstruct [:uuid, :age]

  use ExConstructor
end
