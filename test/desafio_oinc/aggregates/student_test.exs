defmodule DesafioOinc.Studies.StudentTest do
  use DesafioOinc.DataCase, async: false

  import Commanded.Assertions.EventAssertions

  alias DesafioOinc.App
  alias DesafioOinc.Studies.Aggregates.Student, as: StudentsAggregates

  alias DesafioOinc.Studies.Commands.{
    CreateStudent,
    DeleteStudent,
    RestoreStudent,
    UpdateStudent
  }

  alias DesafioOinc.Studies.Events.{
    StudentCreated,
    StudentDeleted,
    StudentRestored,
    StudentNameUpdated,
    StudentAgeUpdated
  }

  describe "event dispatchers" do
    test "when trigger CreateStudent command" do
      %CreateStudent{uuid: uuid} = command = trigger_create_student_command()

      expected_state = command |> Map.from_struct() |> StudentsAggregates.new()

      assert expected_state == App.aggregate_state(StudentsAggregates, uuid)
    end

    test "when trigger DeleteStudent command" do
      %CreateStudent{uuid: uuid, name: name, age: age} = trigger_create_student_command()

      trigger_delete_student_command(uuid)

      assert %StudentsAggregates{uuid: ^uuid, name: ^name, age: ^age, deleted_at: deleted_at} =
               App.aggregate_state(StudentsAggregates, uuid)

      refute is_nil(deleted_at)
    end

    test "when trigger RestoreStudent command" do
      %CreateStudent{uuid: uuid, name: name, age: age} = trigger_create_student_command()

      trigger_restore_student_command(uuid)

      assert %StudentsAggregates{uuid: ^uuid, name: ^name, age: ^age, deleted_at: deleted_at} =
               App.aggregate_state(StudentsAggregates, uuid)

      assert is_nil(deleted_at)
    end

    test "when trigger UpdateStudent command" do
      %CreateStudent{uuid: uuid} = trigger_create_student_command()

      name = "New Named Student"
      age = 30

      trigger_update_student_command(uuid, name, age)

      assert %StudentsAggregates{uuid: ^uuid, name: ^name, age: ^age, deleted_at: deleted_at} =
               App.aggregate_state(StudentsAggregates, uuid)

      assert is_nil(deleted_at)
    end
  end

  defp trigger_create_student_command() do
    uuid = Ecto.UUID.generate()

    create_command = CreateStudent.new(%{uuid: uuid, name: "Name", age: 20})

    :ok = App.dispatch(create_command, consistency: :strong)

    wait_for_event(App, StudentCreated, fn student -> student.uuid == uuid end)

    create_command
  end

  defp trigger_delete_student_command(uuid) do
    delete_command = DeleteStudent.new(%{uuid: uuid})

    :ok = App.dispatch(delete_command, consistency: :strong)

    wait_for_event(App, StudentDeleted, fn student -> student.uuid == uuid end)

    delete_command
  end

  defp trigger_restore_student_command(uuid) do
    restore_command = RestoreStudent.new(%{uuid: uuid})

    :ok = App.dispatch(restore_command, consistency: :strong)

    wait_for_event(App, StudentRestored, fn student -> student.uuid == uuid end)

    restore_command
  end

  defp trigger_update_student_command(uuid, name, age) do
    update_command = UpdateStudent.new(%{uuid: uuid, name: name, age: age})

    :ok = App.dispatch(update_command)

    wait_for_event(App, StudentNameUpdated, fn student -> student.uuid == uuid end)
    wait_for_event(App, StudentAgeUpdated, fn student -> student.uuid == uuid end)

    update_command
  end
end
