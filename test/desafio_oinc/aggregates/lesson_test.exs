defmodule DesafioOinc.Studies.LessonTest do
  use DesafioOinc.DataCase, async: false

  import Commanded.Assertions.EventAssertions
  import DesafioOinc.Fixtures

  alias DesafioOinc.App
  alias DesafioOinc.Studies.Aggregates.Lesson, as: LessonsAggregates

  alias DesafioOinc.Studies.Commands.{
    CreateLesson,
    DeleteLesson,
    RestoreLesson,
    UpdateLesson
  }

  alias DesafioOinc.Studies.Events.{
    LessonCreated,
    LessonDeleted,
    LessonRestored,
    LessonDescriptionUpdated,
    LessonDurationUpdated,
    LessonSubjectUpdated,
    LessonOcurrenceUpdated,
    LessonLecturerIdUpdated,
    LessonStudentIdUpdated
  }

  describe "event dispatchers" do
    test "when trigger CreateLesson command" do
      %CreateLesson{uuid: uuid} = command = trigger_create_lesson_command()

      expected_state = command |> Map.from_struct() |> LessonsAggregates.new()

      assert expected_state == App.aggregate_state(LessonsAggregates, uuid)
    end

    test "when trigger DeleteLesson command" do
      %CreateLesson{uuid: uuid} = trigger_create_lesson_command()

      trigger_delete_lesson_command(uuid)

      assert %LessonsAggregates{uuid: ^uuid, deleted_at: deleted_at} =
               App.aggregate_state(LessonsAggregates, uuid)

      refute is_nil(deleted_at)
    end

    test "when trigger RestoreLesson command" do
      %CreateLesson{uuid: uuid} = trigger_create_lesson_command()

      trigger_restore_lesson_command(uuid)

      assert %LessonsAggregates{uuid: ^uuid, deleted_at: deleted_at} =
               App.aggregate_state(LessonsAggregates, uuid)

      assert is_nil(deleted_at)
    end

    test "when trigger UpdateLesson command" do
      %CreateLesson{uuid: uuid} = trigger_create_lesson_command()

      lecturer = create_lecturer(%{name: "New Person", age: 63})
      student = create_student(%{name: "New Student", age: 25})

      trigger_update_lesson_command(uuid, %{
        description: "New Description",
        duration: "New Duration",
        subject: "New Subject",
        ocurrence: "New Ocurrence",
        lecturer_id: lecturer.uuid,
        student_id: student.uuid
      })

      assert %LessonsAggregates{uuid: ^uuid, deleted_at: deleted_at} = App.aggregate_state(LessonsAggregates, uuid)

      assert is_nil(deleted_at)
    end
  end

  defp trigger_create_lesson_command() do
    uuid = Ecto.UUID.generate()

    lecturer = create_lecturer(%{name: "Lecturer", age: 23})
    student = create_student(%{name: "Student", age: 58})

    create_command =
      CreateLesson.new(%{
        uuid: uuid,
        description: "Description",
        duration: "Duration",
        subject: "Subject",
        ocurrence: "Ocurrence",
        lecturer_id: lecturer.uuid,
        student_id: student.uuid
      })

    :ok = App.dispatch(create_command, consistency: :strong)

    wait_for_event(App, LessonCreated, fn lesson -> lesson.uuid == uuid end)

    create_command
  end

  defp trigger_delete_lesson_command(uuid) do
    delete_command = DeleteLesson.new(%{uuid: uuid})

    :ok = App.dispatch(delete_command, consistency: :strong)

    wait_for_event(App, LessonDeleted, fn lesson -> lesson.uuid == uuid end)

    delete_command
  end

  defp trigger_restore_lesson_command(uuid) do
    restore_command = RestoreLesson.new(%{uuid: uuid})

    :ok = App.dispatch(restore_command, consistency: :strong)

    wait_for_event(App, LessonRestored, fn lesson -> lesson.uuid == uuid end)

    restore_command
  end

  defp trigger_update_lesson_command(uuid, attrs) do
    update_command = UpdateLesson.new(Map.put(attrs, :uuid, uuid))

    :ok = App.dispatch(update_command)

    wait_for_event(App, LessonDescriptionUpdated, fn lesson -> lesson.uuid == uuid end)
    wait_for_event(App, LessonDurationUpdated, fn lesson -> lesson.uuid == uuid end)
    wait_for_event(App, LessonSubjectUpdated, fn lesson -> lesson.uuid == uuid end)
    wait_for_event(App, LessonOcurrenceUpdated, fn lesson -> lesson.uuid == uuid end)
    wait_for_event(App, LessonLecturerIdUpdated, fn lesson -> lesson.uuid == uuid end)
    wait_for_event(App, LessonStudentIdUpdated, fn lesson -> lesson.uuid == uuid end)

    update_command
  end
end
