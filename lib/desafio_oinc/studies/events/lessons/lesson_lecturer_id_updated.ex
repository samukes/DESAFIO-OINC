defmodule DesafioOinc.Studies.Events.LessonLecturerIdUpdated do
  @derive Jason.Encoder
  defstruct [:uuid, :lecturer_id]

  use ExConstructor
end
