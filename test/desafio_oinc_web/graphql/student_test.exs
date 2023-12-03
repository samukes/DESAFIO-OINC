defmodule DesafioOincWeb.Graphql.StudentTest do
  use DesafioOincWeb.ConnCase, async: false

  import DesafioOinc.Fixtures

  setup do
    student = create_student(%{name: "New Student", age: 26})

    %{student: student}
  end

  describe "getStudent/1" do
    test "must return a student", %{conn: conn, student: student} do
      uuid = student.uuid

      conn = post(conn, "/api", %{"query" => get_student_query(), "variables" => %{id: uuid}})

      assert %{
               "data" => %{
                 "getStudent" => %{
                   "age" => 26,
                   "id" => uuid,
                   "name" => "New Student"
                 }
               }
             } == json_response(conn, 200)
    end
  end

  describe "listStudent/1" do
    setup do
      %{uuid: uuid_1} = create_student(%{name: "Name 4", age: 29})
      %{uuid: uuid_2} = create_student(%{name: "Name 5", age: 38})

      :ok = delete_student(uuid_1)
      :ok = delete_student(uuid_2)

      :ok
    end

    @active_students 1
    test "must return active students", %{conn: conn} do
      conn = post(conn, "/api", %{"query" => list_students_query()})

      assert %{
               "data" => %{
                 "listStudents" => [_one] = list_students
               }
             } = json_response(conn, 200)

      assert @active_students == length(list_students)
    end

    @deleted_students 2
    test "listStudent/1 when only_deleted true must return deleted students", %{conn: conn} do
      conn =
        post(conn, "/api", %{
          "query" => list_students_query(),
          "variables" => %{only_deleted: true}
        })

      assert %{
               "data" => %{
                 "listStudents" => [_h | _t] = list_students
               }
             } = json_response(conn, 200)

      assert @deleted_students == length(list_students)
    end
  end

  describe "deleteStudent/1" do
    test "must return a student success deleted message", %{conn: conn, student: student} do
      uuid = student.uuid

      conn =
        post(conn, "/api", %{
          "query" => delete_student_mutation(),
          "variables" => %{id: uuid}
        })

      expected_message = "Success deleted student #{uuid}"

      assert %{"data" => %{"deleteStudent" => %{"message" => ^expected_message}}} =
               json_response(conn, 200)
    end
  end

  describe "restoreStudent/1" do
    setup %{student: student} do
      :ok = delete_student(student.uuid)

      :ok
    end

    test "must return a student success restored message", %{conn: conn, student: student} do
      uuid = student.uuid

      conn =
        post(conn, "/api", %{
          "query" => restore_student_mutation(),
          "variables" => %{id: uuid}
        })

      expected_message = "Success restored student #{uuid}"

      assert %{"data" => %{"restoreStudent" => %{"message" => ^expected_message}}} =
               json_response(conn, 200)
    end
  end

  describe "updateStudent/1" do
    test "must update a student", %{conn: conn, student: student} do
      uuid = student.uuid
      new_name = "Updated Name"
      new_age = 27

      conn =
        post(conn, "/api", %{
          "query" => update_student_mutation(),
          "variables" => %{id: uuid, name: new_name, age: new_age}
        })

      assert %{
               "data" => %{
                 "updateStudent" => %{"id" => ^uuid, "age" => ^new_age, "name" => ^new_name}
               }
             } = json_response(conn, 200)
    end
  end

  describe "createStudent/1" do
    test "must create a student", %{conn: conn} do
      new_name = "Created Name"
      new_age = 65

      conn =
        post(conn, "/api", %{
          "query" => create_student_mutation(),
          "variables" => %{name: new_name, age: new_age}
        })

      assert %{
               "data" => %{
                 "createStudent" => %{"id" => _, "age" => ^new_age, "name" => ^new_name}
               }
             } = json_response(conn, 200)
    end
  end
end
