defmodule DesafioOinc.Studies.Events.LessonSubjectUpdated do
  @derive Jason.Encoder
  defstruct [:uuid, :subject]

  use ExConstructor
end
