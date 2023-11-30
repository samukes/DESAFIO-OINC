defmodule DesafioOinc.Router do
  use Commanded.Commands.Router

  alias DesafioOinc.Lecturers.Aggregates.Lecturer

  alias DesafioOinc.Lecturers.Commands.{CreateLecturer, DeleteLecturer, RestoreLecturer, UpdateLecturer}

  dispatch([CreateLecturer, DeleteLecturer, RestoreLecturer, UpdateLecturer], to: Lecturer, identity: :uuid)
end
