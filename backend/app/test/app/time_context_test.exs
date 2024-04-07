defmodule App.TimeContextTest do
  use App.DataCase

  alias App.TimeContext

  describe "workingtimes" do
    alias App.TimeContext.WorkingTime

    import App.TimeContextFixtures

    @invalid_attrs %{end: nil, start: nil}

    test "list_workingtimes/0 returns all workingtimes" do
      working_time = working_time_fixture()
      assert TimeContext.list_workingtimes() == [working_time]
    end

    test "get_working_time!/1 returns the working_time with given id" do
      working_time = working_time_fixture()
      assert TimeContext.get_working_time!(working_time.id) == working_time
    end

    test "create_working_time/1 with valid data creates a working_time" do
      valid_attrs = %{end: ~N[2022-10-23 22:51:00], start: ~N[2022-10-23 22:51:00]}

      assert {:ok, %WorkingTime{} = working_time} = TimeContext.create_working_time(valid_attrs)
      assert working_time.end == ~N[2022-10-23 22:51:00]
      assert working_time.start == ~N[2022-10-23 22:51:00]
    end

    test "create_working_time/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TimeContext.create_working_time(@invalid_attrs)
    end

    test "update_working_time/2 with valid data updates the working_time" do
      working_time = working_time_fixture()
      update_attrs = %{end: ~N[2022-10-24 22:51:00], start: ~N[2022-10-24 22:51:00]}

      assert {:ok, %WorkingTime{} = working_time} = TimeContext.update_working_time(working_time, update_attrs)
      assert working_time.end == ~N[2022-10-24 22:51:00]
      assert working_time.start == ~N[2022-10-24 22:51:00]
    end

    test "update_working_time/2 with invalid data returns error changeset" do
      working_time = working_time_fixture()
      assert {:error, %Ecto.Changeset{}} = TimeContext.update_working_time(working_time, @invalid_attrs)
      assert working_time == TimeContext.get_working_time!(working_time.id)
    end

    test "delete_working_time/1 deletes the working_time" do
      working_time = working_time_fixture()
      assert {:ok, %WorkingTime{}} = TimeContext.delete_working_time(working_time)
      assert_raise Ecto.NoResultsError, fn -> TimeContext.get_working_time!(working_time.id) end
    end

    test "change_working_time/1 returns a working_time changeset" do
      working_time = working_time_fixture()
      assert %Ecto.Changeset{} = TimeContext.change_working_time(working_time)
    end
  end

  describe "clocks" do
    alias App.TimeContext.Clocks

    import App.TimeContextFixtures

    @invalid_attrs %{start: nil, status: nil}

    test "list_clocks/0 returns all clocks" do
      clocks = clocks_fixture()
      assert TimeContext.list_clocks() == [clocks]
    end

    test "get_clocks!/1 returns the clocks with given id" do
      clocks = clocks_fixture()
      assert TimeContext.get_clocks!(clocks.id) == clocks
    end

    test "create_clocks/1 with valid data creates a clocks" do
      valid_attrs = %{start: ~N[2022-10-23 22:58:00], status: true}

      assert {:ok, %Clocks{} = clocks} = TimeContext.create_clocks(valid_attrs)
      assert clocks.start == ~N[2022-10-23 22:58:00]
      assert clocks.status == true
    end

    test "create_clocks/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TimeContext.create_clocks(@invalid_attrs)
    end

    test "update_clocks/2 with valid data updates the clocks" do
      clocks = clocks_fixture()
      update_attrs = %{start: ~N[2022-10-24 22:58:00], status: false}

      assert {:ok, %Clocks{} = clocks} = TimeContext.update_clocks(clocks, update_attrs)
      assert clocks.start == ~N[2022-10-24 22:58:00]
      assert clocks.status == false
    end

    test "update_clocks/2 with invalid data returns error changeset" do
      clocks = clocks_fixture()
      assert {:error, %Ecto.Changeset{}} = TimeContext.update_clocks(clocks, @invalid_attrs)
      assert clocks == TimeContext.get_clocks!(clocks.id)
    end

    test "delete_clocks/1 deletes the clocks" do
      clocks = clocks_fixture()
      assert {:ok, %Clocks{}} = TimeContext.delete_clocks(clocks)
      assert_raise Ecto.NoResultsError, fn -> TimeContext.get_clocks!(clocks.id) end
    end

    test "change_clocks/1 returns a clocks changeset" do
      clocks = clocks_fixture()
      assert %Ecto.Changeset{} = TimeContext.change_clocks(clocks)
    end
  end
end
