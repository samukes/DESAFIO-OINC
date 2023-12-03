defmodule DesafioOinc.Studies.Commands.UpdateLesson do
  @derive Jason.Encoder
  defstruct [
    :uuid,
    :description,
    :duration,
    :subject,
    :ocurrence,
    :deleted_at,
    :lecturer_id,
    :student_id
  ]

  use ExConstructor

  def assign_changes(%__MODULE__{} = update, changes) do
    description = Map.get(changes, :description, update.description)
    duration = Map.get(changes, :duration, update.duration)
    subject = Map.get(changes, :subject, update.subject)
    ocurrence = Map.get(changes, :ocurrence, update.ocurrence)
    lecturer_id = Map.get(changes, :lecturer_id, update.lecturer_id)
    student_id = Map.get(changes, :student_id, update.student_id)

    %__MODULE__{
      update
      | description: description,
        duration: duration,
        subject: subject,
        ocurrence: ocurrence,
        lecturer_id: lecturer_id,
        student_id: student_id
    }
  end
end
