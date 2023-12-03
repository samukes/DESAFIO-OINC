defmodule DesafioOinc.Router do
  use Commanded.Commands.Router

  alias DesafioOinc.Studies.Aggregates.{Lecturer, Lesson, Student}

  alias DesafioOinc.Studies.Commands.{
    CreateLecturer,
    DeleteLecturer,
    RestoreLecturer,
    UpdateLecturer
  }

  alias DesafioOinc.Studies.Commands.{
    CreateStudent,
    DeleteStudent,
    RestoreStudent,
    UpdateStudent
  }

  alias DesafioOinc.Studies.Commands.{
    CreateLesson,
    DeleteLesson,
    RestoreLesson,
    UpdateLesson
  }

  dispatch([CreateLecturer, DeleteLecturer, RestoreLecturer, UpdateLecturer],
    to: Lecturer,
    identity: :uuid
  )

  dispatch([CreateStudent, DeleteStudent, RestoreStudent, UpdateStudent],
    to: Student,
    identity: :uuid
  )

  dispatch([CreateLesson, DeleteLesson, RestoreLesson, UpdateLesson],
    to: Lesson,
    identity: :uuid
  )
end
