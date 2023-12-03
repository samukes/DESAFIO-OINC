defmodule DesafioOinc.Studies.Events.StudentRestored do
  @derive Jason.Encoder
  defstruct [:uuid]

  use ExConstructor
end
