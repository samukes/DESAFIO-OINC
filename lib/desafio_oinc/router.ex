defmodule DesafioOinc.Router do
  use Commanded.Commands.Router

  alias DesafioOinc.Lecturers.Aggregates.Lecturer

  alias DesafioOinc.Lecturers.Commands.CreateLecturer

  dispatch([CreateLecturer], to: Lecturer, identity: :uuid)
end
