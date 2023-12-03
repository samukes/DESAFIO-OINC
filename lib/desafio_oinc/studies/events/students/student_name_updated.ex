defmodule DesafioOinc.Studies.Events.StudentNameUpdated do
  @derive Jason.Encoder
  defstruct [:uuid, :name]

  use ExConstructor
end
