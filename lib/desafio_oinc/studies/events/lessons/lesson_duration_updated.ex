defmodule DesafioOinc.Studies.Events.LessonDurationUpdated do
  @derive Jason.Encoder
  defstruct [:uuid, :duration]

  use ExConstructor
end
