defmodule DesafioOinc.Studies.Projectors.Lecturer do
  use Commanded.Projections.Ecto,
    name: __MODULE__,
    application: DesafioOinc.App,
    repo: DesafioOinc.Repo,
    consistency: :strong

  alias DesafioOinc.Studies.Projections.Lecturer

  alias DesafioOinc.Studies.Events.{
    LecturerCreated,
    LecturerDeleted,
    LecturerRestored,
    LecturerNameUpdated,
    LecturerAgeUpdated
  }

  alias DesafioOinc.Repo

  alias Ecto.Multi

  project(%LecturerCreated{} = created, _, fn multi ->
    Multi.insert(
      multi,
      :create_lecturer,
      Lecturer.changeset(%Lecturer{}, Map.from_struct(created))
    )
  end)

  project(%LecturerDeleted{uuid: uuid, datetime: datetime}, _, fn multi ->
    case Repo.get(Lecturer, uuid) do
      nil ->
        multi

      old_lecturer ->
        Multi.update(
          multi,
          :soft_delete_lecturer,
          Lecturer.changeset(old_lecturer, %{deleted_at: datetime})
        )
    end
  end)

  project(%LecturerRestored{uuid: uuid}, _, fn multi ->
    case Repo.get(Lecturer, uuid) do
      nil ->
        multi

      old_lecturer ->
        Multi.update(
          multi,
          :soft_restore_lecturer,
          Lecturer.changeset(old_lecturer, %{deleted_at: nil})
        )
    end
  end)

  project(%LecturerNameUpdated{uuid: uuid, name: name}, _, fn multi ->
    case Repo.get(Lecturer, uuid) do
      nil ->
        multi

      old_lecturer ->
        Multi.update(
          multi,
          :update_lecturer_name,
          Lecturer.changeset(old_lecturer, %{name: name})
        )
    end
  end)

  project(%LecturerAgeUpdated{uuid: uuid, age: age}, _, fn multi ->
    case Repo.get(Lecturer, uuid) do
      nil ->
        multi

      old_lecturer ->
        Multi.update(
          multi,
          :update_lecturer_age,
          Lecturer.changeset(old_lecturer, %{age: age})
        )
    end
  end)
end
