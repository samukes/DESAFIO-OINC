defmodule DesafioOinc.Studies.LecturerTest do
  use DesafioOinc.DataCase, async: false

  import Commanded.Assertions.EventAssertions

  alias DesafioOinc.App
  alias DesafioOinc.Studies.Aggregates.Lecturer, as: LecturersAggregates

  alias DesafioOinc.Studies.Commands.{
    CreateLecturer,
    DeleteLecturer,
    RestoreLecturer,
    UpdateLecturer
  }

  alias DesafioOinc.Studies.Events.{
    LecturerCreated,
    LecturerDeleted,
    LecturerRestored,
    LecturerNameUpdated,
    LecturerAgeUpdated
  }

  describe "event dispatchers" do
    test "when trigger CreateLecturer command" do
      %CreateLecturer{uuid: uuid} = command = trigger_create_lecturer_command()

      expected_state = command |> Map.from_struct() |> LecturersAggregates.new()

      assert expected_state == App.aggregate_state(LecturersAggregates, uuid)
    end

    test "when trigger DeleteLecturer command" do
      %CreateLecturer{uuid: uuid, name: name, age: age} = trigger_create_lecturer_command()

      trigger_delete_lecturer_command(uuid)

      assert %LecturersAggregates{uuid: ^uuid, name: ^name, age: ^age, deleted_at: deleted_at} =
               App.aggregate_state(LecturersAggregates, uuid)

      refute is_nil(deleted_at)
    end

    test "when trigger RestoreLecturer command" do
      %CreateLecturer{uuid: uuid, name: name, age: age} = trigger_create_lecturer_command()

      trigger_restore_lecturer_command(uuid)

      assert %LecturersAggregates{uuid: ^uuid, name: ^name, age: ^age, deleted_at: deleted_at} =
               App.aggregate_state(LecturersAggregates, uuid)

      assert is_nil(deleted_at)
    end

    test "when trigger UpdateLecturer command" do
      %CreateLecturer{uuid: uuid} = trigger_create_lecturer_command()

      name = "New Named Lecturer"
      age = 30

      trigger_update_lecturer_command(uuid, name, age)

      assert %LecturersAggregates{uuid: ^uuid, name: ^name, age: ^age, deleted_at: deleted_at} =
               App.aggregate_state(LecturersAggregates, uuid)

      assert is_nil(deleted_at)
    end
  end

  defp trigger_create_lecturer_command() do
    uuid = Ecto.UUID.generate()

    create_command = CreateLecturer.new(%{uuid: uuid, name: "Name", age: 20})

    :ok = App.dispatch(create_command, consistency: :strong)

    wait_for_event(App, LecturerCreated, fn lecturer -> lecturer.uuid == uuid end)

    create_command
  end

  defp trigger_delete_lecturer_command(uuid) do
    delete_command = DeleteLecturer.new(%{uuid: uuid})

    :ok = App.dispatch(delete_command, consistency: :strong)

    wait_for_event(App, LecturerDeleted, fn lecturer -> lecturer.uuid == uuid end)

    delete_command
  end

  defp trigger_restore_lecturer_command(uuid) do
    restore_command = RestoreLecturer.new(%{uuid: uuid})

    :ok = App.dispatch(restore_command, consistency: :strong)

    wait_for_event(App, LecturerRestored, fn lecturer -> lecturer.uuid == uuid end)

    restore_command
  end

  defp trigger_update_lecturer_command(uuid, name, age) do
    update_command = UpdateLecturer.new(%{uuid: uuid, name: name, age: age})

    :ok = App.dispatch(update_command)

    wait_for_event(App, LecturerNameUpdated, fn lecturer -> lecturer.uuid == uuid end)
    wait_for_event(App, LecturerAgeUpdated, fn lecturer -> lecturer.uuid == uuid end)

    update_command
  end
end
