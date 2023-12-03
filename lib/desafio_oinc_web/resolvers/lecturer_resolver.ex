defmodule DesafioOincWeb.Resolvers.LecturerResolver do
  alias DesafioOinc.Studies

  def list_lecturers(_root, args, _info) do
    lecturers =
      Enum.map(Studies.list_lecturers(args), fn lecturer -> lecturer_show_fields(lecturer) end)

    {:ok, lecturers}
  end

  def get_lecture(_root, %{id: id}, _info) do
    case Studies.get_lecturer(id) do
      {:ok, lecturer} -> {:ok, lecturer_show_fields(lecturer)}
      {:error, _, reason} -> {:error, reason}
    end
  end

  def create_lecturer(_root, args, _) do
    case Studies.create_lecturer(args) do
      {:ok, lecturer} -> {:ok, lecturer_show_fields(lecturer)}
      {:error, _, reason} -> {:error, reason}
      error -> error
    end
  end

  def update_lecturer(_root, %{id: id} = args, _) do
    case Studies.update_lecturer(id, args) do
      {:ok, lecturer} -> {:ok, lecturer_show_fields(lecturer)}
      {:error, _, reason} -> {:error, reason}
      error -> error
    end
  end

  def delete_lecturer(_root, %{id: id}, _) do
    case Studies.delete_lecturer(id) do
      {:ok, _} -> {:ok, %{message: "Success deleted lecturer #{id}"}}
      {:error, _, reason} -> {:error, reason}
      error -> error
    end
  end

  def restore_lecturer(_root, %{id: id}, _) do
    case Studies.restore_lecturer(id) do
      {:ok, _} -> {:ok, %{message: "Success restored lecturer #{id}"}}
      {:error, _, reason} -> {:error, reason}
      error -> error
    end
  end

  defp lecturer_show_fields(lecturer) do
    %{id: lecturer.uuid, name: lecturer.name, age: lecturer.age}
  end
end
