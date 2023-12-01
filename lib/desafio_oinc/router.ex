defmodule DesafioOinc.Router do
  use Commanded.Commands.Router

  alias DesafioOinc.Studies.Aggregates.Lecturer

  alias DesafioOinc.Studies.Commands.{
    CreateLecturer,
    DeleteLecturer,
    RestoreLecturer,
    UpdateLecturer
  }

  dispatch([CreateLecturer, DeleteLecturer, RestoreLecturer, UpdateLecturer],
    to: Lecturer,
    identity: :uuid
  )
end
