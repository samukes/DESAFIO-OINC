defmodule DesafioOinc.Studies do
  alias DesafioOinc.Studies.Commands.{
    CreateLecturer,
    DeleteLecturer,
    RestoreLecturer,
    UpdateLecturer
  }

  alias DesafioOinc.Studies.Projections.Lecturer
  alias DesafioOinc.{Repo, App}

  import Ecto.Query

  def get_lecturer(uuid, not_soft_deleted \\ true) do
    query =
      from(l in Lecturer, where: l.uuid == ^uuid, where: is_nil(l.deleted_at) == ^not_soft_deleted)

    case Repo.one(query) do
      nil -> {:error, :not_found, "lecturer not found!"}
      lecturer -> {:ok, lecturer}
    end
  end

  def list_lecturers(attrs) do
    only_deleted = Map.get(attrs, :only_deleted, false)

    query = from(l in Lecturer, where: is_nil(l.deleted_at) != ^only_deleted)

    Repo.all(query)
  end

  def create_lecturer(attrs) do
    uuid = Ecto.UUID.generate()

    create_lecturer_command =
      attrs
      |> CreateLecturer.new()
      |> CreateLecturer.assign_uuid(uuid)

    case App.dispatch(create_lecturer_command, consistency: :strong) do
      :ok -> {:ok, Repo.get!(Lecturer, uuid)}
      reson -> reson
    end
  end

  def delete_lecturer(uuid) do
    with {:ok, lecturer} <- get_lecturer(uuid),
         {:ok, command} <- build_delete_lecturer_commmand(lecturer),
         :ok = result <- App.dispatch(command, consistency: :strong) do
      {:ok, result}
    end
  end

  defp build_delete_lecturer_commmand(lecturer) do
    command =
      lecturer
      |> Map.from_struct()
      |> DeleteLecturer.new()

    {:ok, command}
  end

  def restore_lecturer(uuid) do
    with {:ok, lecturer} <- get_lecturer(uuid, false),
         {:ok, command} <- build_create_lecturer_commmand(lecturer),
         :ok = result <- App.dispatch(command, consistency: :strong) do
      {:ok, result}
    end
  end

  defp build_create_lecturer_commmand(lecturer) do
    command =
      lecturer
      |> Map.from_struct()
      |> RestoreLecturer.new()

    {:ok, command}
  end

  def update_lecturer(uuid, attrs) do
    with {:ok, lecturer} <- get_lecturer(uuid),
         {:ok, command} <- build_update_lecturer_commmand(lecturer, attrs),
         :ok <- App.dispatch(command, consistency: :strong) do
      {:ok, Repo.get!(Lecturer, uuid)}
    end
  end

  defp build_update_lecturer_commmand(lecturer, attrs) do
    command =
      lecturer
      |> Map.from_struct()
      |> UpdateLecturer.new()
      |> UpdateLecturer.assign_changes(attrs)

    {:ok, command}
  end
end
