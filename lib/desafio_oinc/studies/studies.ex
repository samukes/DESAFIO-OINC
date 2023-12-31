defmodule DesafioOinc.Studies do
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

  alias DesafioOinc.Studies.Projections.{Lecturer, Student}
  alias DesafioOinc.{Repo, App}

  import Ecto.Query

  ### Lecturer actions

  def get_lecturer(uuid, not_soft_deleted \\ true) do
    query =
      from(l in Lecturer, where: l.uuid == ^uuid, where: is_nil(l.deleted_at) == ^not_soft_deleted)

    case Repo.one(query) do
      nil -> {:error, :not_found, "Lecturer not found!"}
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

    with :ok <- App.dispatch(create_lecturer_command, consistency: :strong),
         {:ok, _} = result <- get_lecturer(uuid) do
      result
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
         :ok <- App.dispatch(command, consistency: :strong),
         {:ok, _} = result <- get_lecturer(uuid) do
      result
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

  ### Student actions

  def get_student(uuid, not_soft_deleted \\ true) do
    query =
      from(l in Student, where: l.uuid == ^uuid, where: is_nil(l.deleted_at) == ^not_soft_deleted)

    case Repo.one(query) do
      nil -> {:error, :not_found, "Student not found!"}
      student -> {:ok, student}
    end
  end

  def list_students(attrs) do
    only_deleted = Map.get(attrs, :only_deleted, false)

    query = from(l in Student, where: is_nil(l.deleted_at) != ^only_deleted)

    Repo.all(query)
  end

  def create_student(attrs) do
    uuid = Ecto.UUID.generate()

    create_student_command =
      attrs
      |> CreateStudent.new()
      |> CreateStudent.assign_uuid(uuid)

    with :ok <- App.dispatch(create_student_command, consistency: :strong),
         {:ok, _} = result <- get_student(uuid) do
      result
    end
  end

  def delete_student(uuid) do
    with {:ok, student} <- get_student(uuid),
         {:ok, command} <- build_delete_student_commmand(student),
         :ok = result <- App.dispatch(command, consistency: :strong) do
      {:ok, result}
    end
  end

  defp build_delete_student_commmand(student) do
    command =
      student
      |> Map.from_struct()
      |> DeleteStudent.new()

    {:ok, command}
  end

  def restore_student(uuid) do
    with {:ok, student} <- get_student(uuid, false),
         {:ok, command} <- build_create_student_commmand(student),
         :ok = result <- App.dispatch(command, consistency: :strong) do
      {:ok, result}
    end
  end

  defp build_create_student_commmand(student) do
    command =
      student
      |> Map.from_struct()
      |> RestoreStudent.new()

    {:ok, command}
  end

  def update_student(uuid, attrs) do
    with {:ok, student} <- get_student(uuid),
         {:ok, command} <- build_update_student_commmand(student, attrs),
         :ok <- App.dispatch(command, consistency: :strong),
         {:ok, _} = result <- get_student(uuid) do
      result
    end
  end

  defp build_update_student_commmand(student, attrs) do
    command =
      student
      |> Map.from_struct()
      |> UpdateStudent.new()
      |> UpdateStudent.assign_changes(attrs)

    {:ok, command}
  end
end
