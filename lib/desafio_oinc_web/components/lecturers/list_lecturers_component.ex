defmodule DesafioOincWeb.LiveComponents.ListLecturersComponent do
  use Phoenix.LiveComponent

  alias DesafioOinc.Studies

  import DesafioOincWeb.CoreComponents

  def update(_params, socket) do
    socket =
      socket
      |> assign(table_id: "lecturers")
      |> assign(lecturers: Studies.list_lecturers(%{}))
      |> assign(only_deleted: false)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <div class="flex items-center gap-4 w-fulltext-center">
        <div class="flex-1">
          <.button class="mt-2 mb-4" type="button" phx-click="change_user_action" phx-value-user_action="create">Adicionar</.button>
        </div>
        <div class="flex-1 ml-3">
          <.input type="checkbox" name="onlyDeleteds" label="Mostrar somente professores removidos" value={@only_deleted} phx-click="show_only_deleteds" phx-target={@myself}/>
        </div>
      </div>
      <.table id={@table_id} rows={@lecturers} >
        <:col :let={lecturer} label="Nome"><%= lecturer.name %></:col>
        <:col :let={lecturer} label="Idade"><%= lecturer.age %></:col>

        <:action :let={lecturer}>
          <.button :if={is_nil(lecturer.deleted_at)} class="mt-2" type="button" phx-click="change_user_action" phx-value-user_action="update" phx-value-uuid={lecturer.uuid}>Editar</.button>
          <.button :if={is_nil(lecturer.deleted_at)} class="mt-2" type="button" phx-click="delete" phx-value-uuid={lecturer.uuid} phx-value-name={lecturer.name} phx-target={@myself}>Remover</.button>
          <.button :if={!is_nil(lecturer.deleted_at)} class="mt-2" type="button" phx-click="restore" phx-value-uuid={lecturer.uuid} phx-value-name={lecturer.name} phx-target={@myself}>Restaurar</.button>
        </:action>
      </.table>
    </div>
    """
  end

  def handle_event("delete", %{"uuid" => uuid, "name" => name}, socket) do
    {:ok, _} = Studies.delete_lecturer(uuid)

    socket =
      socket
      |> put_flash(:info, "Professor #{name} removido com sucesso!")
      |> redirect(to: "/lecturer")

    {:noreply, socket}
  end

  def handle_event("restore", %{"uuid" => uuid, "name" => name}, socket) do
    {:ok, _} = Studies.restore_lecturer(uuid)

    socket =
      socket
      |> put_flash(:info, "Professor #{name} restaurado com sucesso!")
      |> redirect(to: "/lecturer")

    {:noreply, socket}
  end

  def handle_event("show_only_deleteds", params, socket) do
    value = Map.get(params, "value", socket.assigns.only_deleted)

    socket =
      socket
      |> assign(:only_deleted, value)
      |> assign(lecturers: Studies.list_lecturers(%{only_deleted: value}))

    {:noreply, socket}
  end
end
