defmodule DesafioOinc.Fixtures.Aggregates.Student do
  alias DesafioOinc.Repo

  alias DesafioOinc.Studies.Commands.{
    CreateStudent,
    DeleteStudent,
    UpdateStudent,
    RestoreStudent
  }

  alias DesafioOinc.Studies.Projections.Student

  defmacro __using__(_opts) do
    quote do
      def create_student(attrs \\ %{}) do
        uuid = Map.get(attrs, :uuid, Ecto.UUID.generate())

        command =
          attrs
          |> CreateStudent.new()
          |> CreateStudent.assign_uuid(uuid)

        :ok = DesafioOinc.App.dispatch(command, consistency: :strong)

        Repo.get!(Student, uuid)
      end

      def delete_student(uuid) do
        Repo.get!(Student, uuid)

        command = DeleteStudent.new(%{uuid: uuid})

        :ok = DesafioOinc.App.dispatch(command, consistency: :strong)

        :ok
      end

      def restore_student(uuid) do
        Repo.get!(Student, uuid)

        command = RestoreStudent.new(%{uuid: uuid})

        :ok = DesafioOinc.App.dispatch(command, consistency: :strong)

        :ok
      end

      def update_student(attrs) do
        uuid = Map.fetch!(attrs, :uuid)

        command = UpdateStudent.new(attrs)

        :ok = DesafioOinc.App.dispatch(command, consistency: :strong)

        Repo.get!(Student, uuid)
      end
    end
  end
end
