defmodule DesafioOinc.StudiesTest do
  use DesafioOinc.DataCase, async: false

  import DesafioOinc.Factory

  alias DesafioOinc.Studies

  setup do
    attrs = :lecturer |> build() |> Map.from_struct()

    {:ok, lecturer} = Studies.create_lecturer(attrs)

    %{lecturer: lecturer}
  end

  describe "create_lecturer/1" do
    test "should create a lecturer" do
      attrs = :lecturer |> build() |> Map.from_struct()

      {:ok, lecturer} = Studies.create_lecturer(attrs)

      assert %{age: 32, deleted_at: nil, name: "Lecturer Name"} = lecturer
    end
  end

  describe "delete_lecturer/1" do
    test "should soft delete a lecturer", %{lecturer: lecturer} do
      assert {:ok, _} = Studies.delete_lecturer(lecturer.uuid)
    end
  end

  describe "restore_lecturer/1" do
    test "should soft restore a soft deleted lecturer", %{lecturer: lecturer} do
      {:ok, _} = Studies.delete_lecturer(lecturer.uuid)

      assert {:ok, _} = Studies.restore_lecturer(lecturer.uuid)
    end
  end

  describe "update_lecturer/1" do
    test "should update a lecturer", %{lecturer: lecturer} do
      {:ok, updated_lecturer} = Studies.update_lecturer(lecturer.uuid, %{name: "Another name", age: 23})

      refute lecturer.name == updated_lecturer.name
      refute lecturer.age == updated_lecturer.age
    end
  end

  describe "get_lecturer/1" do
    test "should retrieve a lecturer", %{lecturer: lecturer} do
      assert {:ok, _} = Studies.get_lecturer(lecturer.uuid)
    end

    test "should return error when no valid uuid" do
      assert {:error, :not_found, "lecturer not found!"} =
               Studies.get_lecturer(Ecto.UUID.generate())
    end
  end

  describe "list_lecturer/1" do
    test "should retrieve a lecturer" do
      attrs = :lecturer |> build() |> Map.from_struct()

      Studies.create_lecturer(attrs)

      assert [_head, _second] = Studies.list_lecturers(%{})
    end
  end
end
