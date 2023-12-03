defmodule DesafioOinc.Fixtures.Aggregates.Lesson do
  alias DesafioOinc.Repo

  alias DesafioOinc.Studies.Commands.{
    CreateLesson,
    DeleteLesson,
    UpdateLesson,
    RestoreLesson
  }

  alias DesafioOinc.Studies.Projections.Lesson

  defmacro __using__(_opts) do
    quote do
      def create_lesson(attrs \\ %{}) do
        uuid = Map.get(attrs, :uuid, Ecto.UUID.generate())

        command =
          attrs
          |> CreateLesson.new()
          |> CreateLesson.assign_uuid(uuid)

        :ok = DesafioOinc.App.dispatch(command, consistency: :strong)

        Repo.get!(Lesson, uuid)
      end

      def delete_lesson(uuid) do
        Repo.get!(Lesson, uuid)

        command = DeleteLesson.new(%{uuid: uuid})

        :ok = DesafioOinc.App.dispatch(command, consistency: :strong)

        :ok
      end

      def restore_lesson(uuid) do
        Repo.get!(Lesson, uuid)

        command = RestoreLesson.new(%{uuid: uuid})

        :ok = DesafioOinc.App.dispatch(command, consistency: :strong)

        :ok
      end

      def update_lesson(attrs) do
        uuid = Map.fetch!(attrs, :uuid)

        command = UpdateLesson.new(attrs)

        :ok = DesafioOinc.App.dispatch(command, consistency: :strong)

        Repo.get!(Lesson, uuid)
      end
    end
  end
end
