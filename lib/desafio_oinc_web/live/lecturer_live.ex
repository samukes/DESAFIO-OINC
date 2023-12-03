defmodule DesafioOincWeb.LecturerLive do
  use DesafioOincWeb, :live_view

  alias DesafioOincWeb.LiveComponents.{CreateLecturerComponent, ListLecturersComponent}

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:lecturer_componet_id, Ecto.UUID.generate())
      |> assign(:user_action, "list")

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <%= case @user_action do %>
      <% "list" -> %>
        <.live_component module={ListLecturersComponent} id={@lecturer_componet_id}></.live_component>
      <% "create" -> %>
        <.live_component module={CreateLecturerComponent} id={@lecturer_componet_id}></.live_component>
      <% "update" -> %>
        <.live_component module={CreateLecturerComponent} id={@lecturer_componet_id} uuid={@uuid}></.live_component>
      <% _ -> %>
        <.live_component module={ListLecturersComponent} id={@lecturer_componet_id}></.live_component>
    <% end %>
    """
  end

  def handle_event("change_user_action", %{"user_action" => user_action} = params, socket) do
    socket =
      socket
      |> assign(:user_action, user_action)
      |> assign(:uuid, Map.get(params, "uuid"))

    {:noreply, socket}
  end
end
