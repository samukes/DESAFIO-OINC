defmodule DesafioOinc.Fixtures.Aggregates.Lecturer do
  alias DesafioOinc.Repo

  alias DesafioOinc.Studies.Commands.{
    CreateLecturer,
    DeleteLecturer,
    UpdateLecturer,
    RestoreLecturer
  }

  alias DesafioOinc.Studies.Projections.Lecturer

  defmacro __using__(_opts) do
    quote do
      def create_lecturer(attrs \\ %{}) do
        uuid = Map.get(attrs, :uuid, Ecto.UUID.generate())

        command =
          attrs
          |> CreateLecturer.new()
          |> CreateLecturer.assign_uuid(uuid)

        :ok = DesafioOinc.App.dispatch(command, consistency: :strong)

        Repo.get!(Lecturer, uuid)
      end

      def delete_lecturer(uuid) do
        Repo.get!(Lecturer, uuid)

        command = DeleteLecturer.new(%{uuid: uuid})

        :ok = DesafioOinc.App.dispatch(command, consistency: :strong)

        :ok
      end

      def restore_lecturer(uuid) do
        Repo.get!(Lecturer, uuid)

        command = RestoreLecturer.new(%{uuid: uuid})

        :ok = DesafioOinc.App.dispatch(command, consistency: :strong)

        :ok
      end

      def update_lecturer(attrs) do
        uuid = Map.fetch!(attrs, :uuid)

        command = UpdateLecturer.new(attrs)

        :ok = DesafioOinc.App.dispatch(command, consistency: :strong)

        Repo.get!(Lecturer, uuid)
      end
    end
  end
end
