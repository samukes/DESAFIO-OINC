defmodule DesafioOincWeb.Resolvers.StudentResolver do
  alias DesafioOinc.Studies

  def list_students(_root, args, _info) do
    students =
      Enum.map(Studies.list_students(args), fn student -> student_show_fields(student) end)

    {:ok, students}
  end

  def get_student(_root, %{id: id}, _info) do
    case Studies.get_student(id) do
      {:ok, student} -> {:ok, student_show_fields(student)}
      {:error, _, reason} -> {:error, reason}
    end
  end

  def create_student(_root, args, _) do
    case Studies.create_student(args) do
      {:ok, student} -> {:ok, student_show_fields(student)}
      {:error, _, reason} -> {:error, reason}
      error -> error
    end
  end

  def update_student(_root, %{id: id} = args, _) do
    case Studies.update_student(id, args) do
      {:ok, student} -> {:ok, student_show_fields(student)}
      {:error, _, reason} -> {:error, reason}
      error -> error
    end
  end

  def delete_student(_root, %{id: id}, _) do
    case Studies.delete_student(id) do
      {:ok, _} -> {:ok, %{message: "Success deleted student #{id}"}}
      {:error, _, reason} -> {:error, reason}
      error -> error
    end
  end

  def restore_student(_root, %{id: id}, _) do
    case Studies.restore_student(id) do
      {:ok, _} -> {:ok, %{message: "Success restored student #{id}"}}
      {:error, _, reason} -> {:error, reason}
      error -> error
    end
  end

  defp student_show_fields(student) do
    %{id: student.uuid, name: student.name, age: student.age}
  end
end
