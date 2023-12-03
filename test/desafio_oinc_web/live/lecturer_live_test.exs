defmodule DesafioOincWeb.LecturerLiveTest do
  use DesafioOincWeb.ConnCase

  import DesafioOinc.Fixtures
  import Phoenix.LiveViewTest

  test "disconnected and connected mount", %{conn: conn} do
    conn = get(conn, "/lecturer")
    assert "<!DOCTYPE html>" <> _ = html_response(conn, 200)

    {:ok, view, html} = live(conn)

    assert "<html " <> _ = html
    assert %Phoenix.LiveViewTest.View{module: DesafioOincWeb.LecturerLive} = view
  end

  test "handle event change_user_action to create", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/lecturer")

    assert "<header " <> _ = render_click(view, :change_user_action, %{"user_action" => "create"})
  end

  test "handle event change_user_action to update", %{conn: conn} do
    lecturer = create_lecturer(%{name: "New Lecturer", age: 28})

    {:ok, view, _html} = live(conn, "/lecturer")

    assert "<header " <> _ = render_click(view, :change_user_action, %{"user_action" => "update", "uuid" => lecturer.uuid})
  end

  test "handle event change_user_action unkown trigger", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/lecturer")

    assert "<header " <> _ = render_click(view, :change_user_action, %{"user_action" => "unkown"})
  end
end
