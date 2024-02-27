defmodule CalenDazeWeb.CalendarConfLive.FormComponent do
  use CalenDazeWeb, :live_component

  alias CalenDaze.Business

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage calendar_conf records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="calendar_conf-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >

        <:actions>
          <.button phx-disable-with="Saving...">Save Calendar conf</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{calendar_conf: calendar_conf} = assigns, socket) do
    changeset = Business.change_calendar_conf(calendar_conf)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"calendar_conf" => calendar_conf_params}, socket) do
    changeset =
      socket.assigns.calendar_conf
      |> Business.change_calendar_conf(calendar_conf_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"calendar_conf" => calendar_conf_params}, socket) do
    save_calendar_conf(socket, socket.assigns.action, calendar_conf_params)
  end

  defp save_calendar_conf(socket, :edit, calendar_conf_params) do
    case Business.update_calendar_conf(socket.assigns.calendar_conf, calendar_conf_params) do
      {:ok, calendar_conf} ->
        notify_parent({:saved, calendar_conf})

        {:noreply,
         socket
         |> put_flash(:info, "Calendar conf updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_calendar_conf(socket, :new, calendar_conf_params) do
    case Business.create_calendar_conf(calendar_conf_params) do
      {:ok, calendar_conf} ->
        notify_parent({:saved, calendar_conf})

        {:noreply,
         socket
         |> put_flash(:info, "Calendar conf created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
