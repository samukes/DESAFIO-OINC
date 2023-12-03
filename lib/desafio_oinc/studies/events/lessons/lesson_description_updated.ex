defmodule DesafioOinc.Studies.Events.LessonDescriptionUpdated do
  @derive Jason.Encoder
  defstruct [:uuid, :description]

  use ExConstructor
end
