defmodule DesafioOincWeb.Graphql.LecturerTest do
  use DesafioOincWeb.ConnCase, async: false

  import DesafioOinc.Fixtures

  setup do
    lecturer = create_lecturer(%{name: "New Lecturer", age: 26})

    %{lecturer: lecturer}
  end

  describe "getLecturer/1" do
    test "must return a lecturer", %{conn: conn, lecturer: lecturer} do
      uuid = lecturer.uuid

      conn = post(conn, "/api", %{"query" => get_lecturer_query(), "variables" => %{id: uuid}})

      assert %{
               "data" => %{
                 "getLecturer" => %{
                   "age" => 26,
                   "id" => uuid,
                   "name" => "New Lecturer"
                 }
               }
             } == json_response(conn, 200)
    end
  end

  describe "listLecturer/1" do
    setup do
      %{uuid: uuid_1} = create_lecturer(%{name: "Name 4", age: 29})
      %{uuid: uuid_2} = create_lecturer(%{name: "Name 5", age: 38})

      :ok = delete_lecturer(uuid_1)
      :ok = delete_lecturer(uuid_2)

      :ok
    end

    @active_lecturers 1
    test "must return active lecturers", %{conn: conn} do
      conn = post(conn, "/api", %{"query" => list_lectuers_query()})

      assert %{
               "data" => %{
                 "listLecturers" => [_one] = list_lecturers
               }
             } = json_response(conn, 200)

      assert @active_lecturers == length(list_lecturers)
    end

    @deleted_lecturers 2
    test "listLecturer/1 when only_deleted true must return deleted lecturers", %{conn: conn} do
      conn =
        post(conn, "/api", %{
          "query" => list_lectuers_query(),
          "variables" => %{only_deleted: true}
        })

      assert %{
               "data" => %{
                 "listLecturers" => [_h | _t] = list_lecturers
               }
             } = json_response(conn, 200)

      assert @deleted_lecturers == length(list_lecturers)
    end
  end

  describe "deleteLecturer/1" do
    test "must return a lecturer success deleted message", %{conn: conn, lecturer: lecturer} do
      uuid = lecturer.uuid

      conn =
        post(conn, "/api", %{
          "query" => delete_lecturer_mutation(),
          "variables" => %{id: uuid}
        })

      expected_message = "Success deleted lecturer #{uuid}"

      assert %{"data" => %{"deleteLecturer" => %{"message" => ^expected_message}}} =
               json_response(conn, 200)
    end
  end

  describe "restoreLecturer/1" do
    setup %{lecturer: lecturer} do
      :ok = delete_lecturer(lecturer.uuid)

      :ok
    end

    test "must return a lecturer success restored message", %{conn: conn, lecturer: lecturer} do
      uuid = lecturer.uuid

      conn =
        post(conn, "/api", %{
          "query" => restore_lecturer_mutation(),
          "variables" => %{id: uuid}
        })

      expected_message = "Success restored lecturer #{uuid}"

      assert %{"data" => %{"restoreLecturer" => %{"message" => ^expected_message}}} =
               json_response(conn, 200)
    end
  end

  describe "updateLecturer/1" do
    test "must update a lecturer", %{conn: conn, lecturer: lecturer} do
      uuid = lecturer.uuid
      new_name = "Updated Name"
      new_age = 27

      conn =
        post(conn, "/api", %{
          "query" => update_lecturer_mutation(),
          "variables" => %{id: uuid, name: new_name, age: new_age}
        })

      assert %{
               "data" => %{
                 "updateLecturer" => %{"id" => ^uuid, "age" => ^new_age, "name" => ^new_name}
               }
             } = json_response(conn, 200)
    end
  end

  describe "createLecturer/1" do
    test "must create a lecturer", %{conn: conn} do
      new_name = "Created Name"
      new_age = 65

      conn =
        post(conn, "/api", %{
          "query" => create_lecturer_mutation(),
          "variables" => %{name: new_name, age: new_age}
        })

      assert %{
               "data" => %{
                 "createLecturer" => %{"id" => _, "age" => ^new_age, "name" => ^new_name}
               }
             } = json_response(conn, 200)
    end
  end
end
