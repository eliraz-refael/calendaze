defmodule CalenDaze.BusinessTest do
  use CalenDaze.DataCase

  alias CalenDaze.Business

  describe "calendar_confs" do
    alias CalenDaze.Business.CalendarConf

    import CalenDaze.BusinessFixtures

    @invalid_attrs %{work_hours: nil}

    test "list_calendar_confs/0 returns all calendar_confs" do
      calendar_conf = calendar_conf_fixture()
      assert Business.list_calendar_confs() == [calendar_conf]
    end

    test "get_calendar_conf!/1 returns the calendar_conf with given id" do
      calendar_conf = calendar_conf_fixture()
      assert Business.get_calendar_conf!(calendar_conf.id) == calendar_conf
    end

    test "create_calendar_conf/1 with valid data creates a calendar_conf" do
      valid_attrs = %{work_hours: %{}}

      assert {:ok, %CalendarConf{} = calendar_conf} = Business.create_calendar_conf(valid_attrs)
      assert calendar_conf.work_hours == %{}
    end

    test "create_calendar_conf/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Business.create_calendar_conf(@invalid_attrs)
    end

    test "update_calendar_conf/2 with valid data updates the calendar_conf" do
      calendar_conf = calendar_conf_fixture()
      update_attrs = %{work_hours: %{}}

      assert {:ok, %CalendarConf{} = calendar_conf} = Business.update_calendar_conf(calendar_conf, update_attrs)
      assert calendar_conf.work_hours == %{}
    end

    test "update_calendar_conf/2 with invalid data returns error changeset" do
      calendar_conf = calendar_conf_fixture()
      assert {:error, %Ecto.Changeset{}} = Business.update_calendar_conf(calendar_conf, @invalid_attrs)
      assert calendar_conf == Business.get_calendar_conf!(calendar_conf.id)
    end

    test "delete_calendar_conf/1 deletes the calendar_conf" do
      calendar_conf = calendar_conf_fixture()
      assert {:ok, %CalendarConf{}} = Business.delete_calendar_conf(calendar_conf)
      assert_raise Ecto.NoResultsError, fn -> Business.get_calendar_conf!(calendar_conf.id) end
    end

    test "change_calendar_conf/1 returns a calendar_conf changeset" do
      calendar_conf = calendar_conf_fixture()
      assert %Ecto.Changeset{} = Business.change_calendar_conf(calendar_conf)
    end
  end
end
