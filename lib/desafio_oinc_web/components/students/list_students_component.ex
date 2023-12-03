defmodule DesafioOincWeb.LiveComponents.ListStudentsComponent do
  use Phoenix.LiveComponent

  alias DesafioOinc.Studies

  import DesafioOincWeb.CoreComponents

  def update(_params, socket) do
    socket =
      socket
      |> assign(table_id: "students")
      |> assign(students: Studies.list_students(%{}))
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
          <.input type="checkbox" name="onlyDeleteds" label="Mostrar somente estudantes removidos" value={@only_deleted} phx-click="show_only_deleteds" phx-target={@myself}/>
        </div>
      </div>
      <.table id={@table_id} rows={@students} >
        <:col :let={student} label="Nome"><%= student.name %></:col>
        <:col :let={student} label="Idade"><%= student.age %></:col>

        <:action :let={student}>
          <.button :if={is_nil(student.deleted_at)} class="mt-2" type="button" phx-click="change_user_action" phx-value-user_action="update" phx-value-uuid={student.uuid}>Editar</.button>
          <.button :if={is_nil(student.deleted_at)} class="mt-2" type="button" phx-click="delete" phx-value-uuid={student.uuid} phx-value-name={student.name} phx-target={@myself}>Remover</.button>
          <.button :if={!is_nil(student.deleted_at)} class="mt-2" type="button" phx-click="restore" phx-value-uuid={student.uuid} phx-value-name={student.name} phx-target={@myself}>Restaurar</.button>
        </:action>
      </.table>
    </div>
    """
  end

  def handle_event("delete", %{"uuid" => uuid, "name" => name}, socket) do
    {:ok, _} = Studies.delete_student(uuid)

    socket =
      socket
      |> put_flash(:info, "Estudante #{name} removido com sucesso!")
      |> redirect(to: "/student")

    {:noreply, socket}
  end

  def handle_event("restore", %{"uuid" => uuid, "name" => name}, socket) do
    {:ok, _} = Studies.restore_student(uuid)

    socket =
      socket
      |> put_flash(:info, "Estudante #{name} restaurado com sucesso!")
      |> redirect(to: "/student")

    {:noreply, socket}
  end

  def handle_event("show_only_deleteds", params, socket) do
    value = Map.get(params, "value", socket.assigns.only_deleted)

    socket =
      socket
      |> assign(:only_deleted, value)
      |> assign(students: Studies.list_students(%{only_deleted: value}))

    {:noreply, socket}
  end
end
