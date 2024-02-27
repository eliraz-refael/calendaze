defmodule CalenDazeWeb.CalendarConfLiveTest do
  use CalenDazeWeb.ConnCase

  import Phoenix.LiveViewTest
  import CalenDaze.BusinessFixtures

  @create_attrs %{work_hours: %{}}
  @update_attrs %{work_hours: %{}}
  @invalid_attrs %{work_hours: nil}

  defp create_calendar_conf(_) do
    calendar_conf = calendar_conf_fixture()
    %{calendar_conf: calendar_conf}
  end

  describe "Index" do
    setup [:create_calendar_conf]

    test "lists all calendar_confs", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/calendar_confs")

      assert html =~ "Listing Calendar confs"
    end

    test "saves new calendar_conf", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/calendar_confs")

      assert index_live |> element("a", "New Calendar conf") |> render_click() =~
               "New Calendar conf"

      assert_patch(index_live, ~p"/calendar_confs/new")

      assert index_live
             |> form("#calendar_conf-form", calendar_conf: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#calendar_conf-form", calendar_conf: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/calendar_confs")

      html = render(index_live)
      assert html =~ "Calendar conf created successfully"
    end

    test "updates calendar_conf in listing", %{conn: conn, calendar_conf: calendar_conf} do
      {:ok, index_live, _html} = live(conn, ~p"/calendar_confs")

      assert index_live |> element("#calendar_confs-#{calendar_conf.id} a", "Edit") |> render_click() =~
               "Edit Calendar conf"

      assert_patch(index_live, ~p"/calendar_confs/#{calendar_conf}/edit")

      assert index_live
             |> form("#calendar_conf-form", calendar_conf: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#calendar_conf-form", calendar_conf: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/calendar_confs")

      html = render(index_live)
      assert html =~ "Calendar conf updated successfully"
    end

    test "deletes calendar_conf in listing", %{conn: conn, calendar_conf: calendar_conf} do
      {:ok, index_live, _html} = live(conn, ~p"/calendar_confs")

      assert index_live |> element("#calendar_confs-#{calendar_conf.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#calendar_confs-#{calendar_conf.id}")
    end
  end

  describe "Show" do
    setup [:create_calendar_conf]

    test "displays calendar_conf", %{conn: conn, calendar_conf: calendar_conf} do
      {:ok, _show_live, html} = live(conn, ~p"/calendar_confs/#{calendar_conf}")

      assert html =~ "Show Calendar conf"
    end

    test "updates calendar_conf within modal", %{conn: conn, calendar_conf: calendar_conf} do
      {:ok, show_live, _html} = live(conn, ~p"/calendar_confs/#{calendar_conf}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Calendar conf"

      assert_patch(show_live, ~p"/calendar_confs/#{calendar_conf}/show/edit")

      assert show_live
             |> form("#calendar_conf-form", calendar_conf: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#calendar_conf-form", calendar_conf: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/calendar_confs/#{calendar_conf}")

      html = render(show_live)
      assert html =~ "Calendar conf updated successfully"
    end
  end
end
