defmodule DesafioOinc.Studies.Events.LessonOcurrenceUpdated do
  @derive Jason.Encoder
  defstruct [:uuid, :ocurrence]

  use ExConstructor
end
