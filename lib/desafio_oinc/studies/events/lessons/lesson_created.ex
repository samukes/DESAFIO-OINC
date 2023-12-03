defmodule DesafioOinc.Studies.Events.LessonCreated do
  @derive Jason.Encoder
  defstruct [:uuid, :description, :duration, :subject, :ocurrence, :lecturer_id, :student_id, deleted_at: nil]
end
