defmodule DesafioOinc.Studies.Aggregates.Lesson do
  @derive Jason.Encoder
  defstruct [
    :uuid,
    :description,
    :duration,
    :subject,
    :ocurrence,
    :lecturer_id,
    :student_id,
    deleted_at: nil
  ]

  use ExConstructor

  alias DesafioOinc.Studies.Commands.{
    CreateLesson,
    DeleteLesson,
    RestoreLesson,
    UpdateLesson
  }

  alias DesafioOinc.Studies.Events.{
    LessonCreated,
    LessonDeleted,
    LessonRestored,
    LessonDescriptionUpdated,
    LessonDurationUpdated,
    LessonSubjectUpdated,
    LessonOcurrenceUpdated,
    LessonLecturerIdUpdated,
    LessonStudentIdUpdated
  }

  def execute(%__MODULE__{uuid: nil}, %CreateLesson{} = create) do
    %LessonCreated{
      uuid: create.uuid,
      description: create.description,
      duration: create.duration,
      subject: create.subject,
      ocurrence: create.ocurrence,
      lecturer_id: create.lecturer_id,
      student_id: create.student_id
    }
  end

  def execute(%__MODULE__{uuid: uuid, deleted_at: nil}, %DeleteLesson{}) do
    %LessonDeleted{
      uuid: uuid,
      datetime: DateTime.utc_now()
    }
  end

  def execute(%__MODULE__{uuid: uuid}, %RestoreLesson{}) do
    %LessonRestored{
      uuid: uuid
    }
  end

  def execute(%__MODULE__{} = lesson, %UpdateLesson{} = update) do
    update_description_command =
      if not is_nil(update.description) && lesson.description != update.description,
        do: %LessonDescriptionUpdated{uuid: update.uuid, description: update.description}

    update_duration_command =
      if not is_nil(update.duration) && lesson.duration != update.duration,
        do: %LessonDurationUpdated{uuid: update.uuid, duration: update.duration}

    update_subject_command =
      if not is_nil(update.subject) && lesson.subject != update.subject,
        do: %LessonSubjectUpdated{uuid: update.uuid, subject: update.subject}

    update_ocurrence_command =
      if not is_nil(update.ocurrence) && lesson.ocurrence != update.ocurrence,
        do: %LessonOcurrenceUpdated{uuid: update.uuid, ocurrence: update.ocurrence}

    update_lecturer_id_command =
      if not is_nil(update.lecturer_id) && lesson.lecturer_id != update.lecturer_id,
        do: %LessonLecturerIdUpdated{uuid: update.uuid, lecturer_id: update.lecturer_id}

    update_student_id_command =
      if not is_nil(update.student_id) && lesson.student_id != update.student_id,
        do: %LessonStudentIdUpdated{uuid: update.uuid, student_id: update.student_id}

    Enum.filter(
      [
        update_description_command,
        update_duration_command,
        update_subject_command,
        update_ocurrence_command,
        update_lecturer_id_command,
        update_student_id_command
      ],
      &(!is_nil(&1))
    )
  end

  def apply(%__MODULE__{} = lesson, %LessonCreated{} = created) do
    %__MODULE__{
      lesson
      | uuid: created.uuid,
        description: created.description,
        duration: created.duration,
        subject: created.subject,
        ocurrence: created.ocurrence,
        lecturer_id: created.lecturer_id,
        student_id: created.student_id
    }
  end

  def apply(%__MODULE__{deleted_at: nil} = lesson, %LessonDeleted{
        datetime: effective_datetime
      }) do
    %__MODULE__{lesson | deleted_at: effective_datetime}
  end

  def apply(%__MODULE__{} = lesson, %LessonRestored{}) do
    %__MODULE__{lesson | deleted_at: nil}
  end

  def apply(%__MODULE__{} = lesson, %LessonDescriptionUpdated{description: description}) do
    %__MODULE__{lesson | description: description}
  end

  def apply(%__MODULE__{} = lesson, %LessonDurationUpdated{duration: duration}) do
    %__MODULE__{lesson | duration: duration}
  end

  def apply(%__MODULE__{} = lesson, %LessonSubjectUpdated{subject: subject}) do
    %__MODULE__{lesson | subject: subject}
  end

  def apply(%__MODULE__{} = lesson, %LessonOcurrenceUpdated{ocurrence: ocurrence}) do
    %__MODULE__{lesson | ocurrence: ocurrence}
  end

  def apply(%__MODULE__{} = lesson, %LessonLecturerIdUpdated{lecturer_id: lecturer_id}) do
    %__MODULE__{lesson | lecturer_id: lecturer_id}
  end

  def apply(%__MODULE__{} = lesson, %LessonStudentIdUpdated{student_id: student_id}) do
    %__MODULE__{lesson | student_id: student_id}
  end
end
