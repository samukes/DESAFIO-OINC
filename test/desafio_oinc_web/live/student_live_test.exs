defmodule DesafioOincWeb.StudentLiveTest do
  use DesafioOincWeb.ConnCase, ascyn: true

  import DesafioOinc.Fixtures
  import Phoenix.LiveViewTest

  test "disconnected and connected mount", %{conn: conn} do
    conn = get(conn, "/student")
    assert "<!DOCTYPE html>" <> _ = html_response(conn, 200)

    {:ok, view, html} = live(conn)

    assert "<html " <> _ = html
    assert %Phoenix.LiveViewTest.View{module: DesafioOincWeb.StudentLive} = view
  end

  test "handle event change_user_action to create", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/student")

    assert "<header " <> _ = render_click(view, :change_user_action, %{"user_action" => "create"})
  end

  test "handle event change_user_action to update", %{conn: conn} do
    student = create_student(%{name: "New Student", age: 28})

    {:ok, view, _html} = live(conn, "/student")

    assert "<header " <> _ = render_click(view, :change_user_action, %{"user_action" => "update", "uuid" => student.uuid})
  end

  test "handle event change_user_action unkown trigger", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/student")

    assert "<header " <> _ = render_click(view, :change_user_action, %{"user_action" => "unkown"})
  end
end
