defmodule DesafioOinc.Studies.Commands.CreateLesson do
  @derive Jason.Encoder
  defstruct [:uuid, :description, :duration, :subject, :ocurrence, :lecturer_id, :student_id, deleted_at: nil]

  use ExConstructor

  def assign_uuid(%__MODULE__{} = create, uuid) do
    %__MODULE__{create | uuid: uuid}
  end
end
