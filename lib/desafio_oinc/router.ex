defmodule DesafioOinc.Router do
  use Commanded.Commands.Router

  alias DesafioOinc.Studies.Aggregates.{Lecturer, Student}

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

  dispatch([CreateLecturer, DeleteLecturer, RestoreLecturer, UpdateLecturer],
    to: Lecturer,
    identity: :uuid
  )

  dispatch([CreateStudent, DeleteStudent, RestoreStudent, UpdateStudent],
    to: Student,
    identity: :uuid
  )
end
