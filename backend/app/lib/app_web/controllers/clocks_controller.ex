defmodule AppWeb.ClocksController do
  use AppWeb, :controller

  alias AppWeb.UserController
  alias App.TimeContext
  # alias App.TimeContext.Clocks

  action_fallback AppWeb.FallbackController


  ### default functions ###

  ### check if user is logged in ###
  plug :check_auth when action in [:get_clock_from_userId, :update_clock_from_userId, :get_clock_from_logged_user, :update_clock_from_logged_user]

  defp check_auth(conn, params) do
    UserController.check_auth(conn, params)
  end

  ### end of default functions ###


  ### RETRIEVE CLOCK ###
  def get_clock(conn, userId) do
    clocks = TimeContext.get_clocks_by_user(userId)

    if clocks == [] do
      conn
      |> render(AppWeb.ClocksView, "info.json", info: "Clock no set yet")
    else
      conn
      |> render(AppWeb.ClocksView, "index.json", clocks: clocks)
    end
  end

  def get_clock_from_userId(conn, %{ "userID" => userId }) do
    get_clock(conn, userId)
  end

  def get_clock_from_logged_user(conn, _params) do
    userId = conn.assigns[:user_id]
    get_clock(conn, userId)
  end

  ### UPDATE CLOCK ###

  def check_if_clock_exists(user) do
    clock = TimeContext.get_clock_of_user(user)
    if clock == nil do
      TimeContext.create_clocks(%{"user" => user, "start" => DateTime.utc_now(), "status" => false})
      TimeContext.get_clock_of_user(user)
    else
      clock
    end
  end

  def update_clock(conn, %{"userID" => userId}) do
    clock = check_if_clock_exists(userId)

    if clock.status == false do
      clock = TimeContext.update_clocks(clock, %{"user" => clock.user, "start" => DateTime.utc_now(), "status" => true})
      render(conn, "show.json", clocks: elem(clock, 1))
    else
      clock = TimeContext.update_clocks(clock, %{"user" => clock.user, "start" => clock.start, "status" => false})
      clock = elem(clock, 1)
      TimeContext.create_working_time(
        %{"user" => clock.user,
        "start" => clock.start,
        "end" => DateTime.utc_now()})
      render(conn, "show.json", clocks: clock)
    end
  end

  def update_clock_from_userId(conn, %{"userID" => userId}) do
    UserController.verify_user_id_and_return_user(conn, userId)
    update_clock(conn, %{"userID" => userId})
  end

  def update_clock_from_logged_user(conn, _params) do
    userId = conn.assigns[:user_id]
    update_clock(conn, %{"userID" => userId})
  end
end
