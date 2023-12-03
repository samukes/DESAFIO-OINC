defmodule DesafioOinc.Studies.Events.LessonRestored do
  @derive Jason.Encoder
  defstruct [:uuid]

  use ExConstructor
end
