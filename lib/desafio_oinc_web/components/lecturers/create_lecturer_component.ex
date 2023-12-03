defmodule DesafioOincWeb.LiveComponents.CreateLecturerComponent do
  use Phoenix.LiveComponent

  alias DesafioOinc.Studies
  alias DesafioOinc.Studies.Projections.Lecturer

  import DesafioOincWeb.CoreComponents

  def update(%{uuid: id}, socket) when is_binary(id) do
    {:ok, lecturer} = Studies.get_lecturer(id)

    form =
      lecturer
      |> Lecturer.changeset()
      |> to_form()

    socket =
      socket
      |> assign(form: form)
      |> assign(form_submit: "update")

    {:ok, socket}
  end

  def update(_params, socket) do
    socket =
      socket
      |> assign(form: to_form(Lecturer.changeset(%Lecturer{})))
      |> assign(form_submit: "save")

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1 :if={@form_submit == "save"}>Inserir um novo Professor</h1>
      <h1 :if={@form_submit == "update"}>Atualizar os dados de um Professor</h1>
      <.form for={@form} phx-change="validate" phx-submit={@form_submit} phx-target={@myself}>
        <.input field={@form[:uuid]} type="hidden"/>
        <div class="mt-2">
          <.input field={@form[:name]} label="Nome"/>
        </div>
        <div class="mt-2">
          <.input field={@form[:age]} label="Idade" type="number" inputmode="numeric" pattern="[0-9]*"/>
        </div>
        <action>
          <.button class="mt-2 mb-4" type="button" phx-click="change_user_action" phx-value-user_action="list">Voltar</.button>
          <.button class="mt-2" type="submit">Salvar</.button>
        </action>
      </.form>
    </div>
    """
  end

  def handle_event("validate", %{"lecturer" => params}, socket) do
    {:noreply, assign(socket, :form, validate_inputs(params))}
  end

  def handle_event("save", %{"lecturer" => params}, socket) do
    %{source: %{valid?: valid?}} = form = validate_inputs(params)

    if valid? do
      case Studies.create_lecturer(params) do
        {:ok, _} ->
          socket =
            socket
            |> put_flash(:info, "Professor #{params["name"]} criado com sucesso!")
            |> redirect(to: "/lecturer")

          {:noreply, socket}

        {:error, reason} ->
          {:noreply, put_flash(socket, :error, inspect(reason, pretty: true))}
      end
    else
      {:noreply, assign(socket, :form, form)}
    end
  end

  def handle_event("update", %{"lecturer" => params}, socket) do
    %{source: %{valid?: valid?}} = form = validate_inputs(params)

    if valid? do
      case Studies.update_lecturer(params["uuid"], %{name: params["name"], age: params["age"]}) do
        {:ok, _} ->
          socket =
            socket
            |> put_flash(:info, "Professor #{params["name"]} alterado com sucesso!")
            |> redirect(to: "/lecturer")

          {:noreply, socket}

        {:error, reason} ->
          {:noreply, put_flash(socket, :error, inspect(reason, pretty: true))}
      end
    else
      {:noreply, assign(socket, :form, form)}
    end
  end

  defp validate_inputs(params) do
    %Lecturer{}
    |> Lecturer.changeset(params)
    |> Map.put(:action, :insert)
    |> to_form()
  end
end
