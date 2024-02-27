defmodule CalenDazeWeb.CalendarConfLive.Index do
  use CalenDazeWeb, :live_view

  alias CalenDaze.Business
  alias CalenDaze.Business.CalendarConf

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :calendar_confs, Business.list_calendar_confs())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Calendar conf")
    |> assign(:calendar_conf, Business.get_calendar_conf!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Calendar conf")
    |> assign(:calendar_conf, %CalendarConf{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Calendar confs")
    |> assign(:calendar_conf, nil)
  end

  @impl true
  def handle_info({CalenDazeWeb.CalendarConfLive.FormComponent, {:saved, calendar_conf}}, socket) do
    {:noreply, stream_insert(socket, :calendar_confs, calendar_conf)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    calendar_conf = Business.get_calendar_conf!(id)
    {:ok, _} = Business.delete_calendar_conf(calendar_conf)

    {:noreply, stream_delete(socket, :calendar_confs, calendar_conf)}
  end
end
