defmodule DesafioOinc.Studies.Projectors.Student do
  use Commanded.Projections.Ecto,
    name: "LecturesProjectors",
    application: DesafioOinc.App,
    repo: DesafioOinc.Repo,
    consistency: :strong

  alias DesafioOinc.Studies.Projections.Student

  alias DesafioOinc.Studies.Events.{
    StudentCreated,
    StudentDeleted,
    StudentRestored,
    StudentNameUpdated,
    StudentAgeUpdated
  }

  alias DesafioOinc.Repo

  alias Ecto.Multi

  project(%StudentCreated{} = created, _, fn multi ->
    Multi.insert(
      multi,
      :create_student,
      Student.changeset(%Student{}, Map.from_struct(created))
    )
  end)

  project(%StudentDeleted{uuid: uuid, datetime: datetime}, _, fn multi ->
    case Repo.get(Student, uuid) do
      nil ->
        multi

      old_student ->
        Multi.update(
          multi,
          :soft_delete_student,
          Student.changeset(old_student, %{deleted_at: datetime})
        )
    end
  end)

  project(%StudentRestored{uuid: uuid}, _, fn multi ->
    case Repo.get(Student, uuid) do
      nil ->
        multi

      old_student ->
        Multi.update(
          multi,
          :soft_restore_student,
          Student.changeset(old_student, %{deleted_at: nil})
        )
    end
  end)

  project(%StudentNameUpdated{uuid: uuid, name: name}, _, fn multi ->
    case Repo.get(Student, uuid) do
      nil ->
        multi

      old_student ->
        Multi.update(
          multi,
          :update_student_name,
          Student.changeset(old_student, %{name: name})
        )
    end
  end)

  project(%StudentAgeUpdated{uuid: uuid, age: age}, _, fn multi ->
    case Repo.get(Student, uuid) do
      nil ->
        multi

      old_student ->
        Multi.update(
          multi,
          :update_student_age,
          Student.changeset(old_student, %{age: age})
        )
    end
  end)
end
