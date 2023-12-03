defmodule DesafioOinc.Studies.Events.LessonStudentIdUpdated do
  @derive Jason.Encoder
  defstruct [:uuid, :student_id]

  use ExConstructor
end
