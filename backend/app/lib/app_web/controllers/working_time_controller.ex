defmodule AppWeb.WorkingTimeController do
  use AppWeb, :controller

  alias App.TimeContext
  alias App.TimeContext.WorkingTime
  alias AppWeb.UserController

  action_fallback AppWeb.FallbackController

  plug :check_auth when action in [:index_of_user, :show, :create, :update, :delete, :get_working_time_from_logged_user, :create_from_logged_user]

  def check_auth(conn, param) do
    UserController.check_auth(conn, param)
  end

  def checkTime(startTime, defaultValue) do
    if is_nil(startTime) do
      defaultValue
    else
      startTime
    end
  end

  def index_of_user(conn, %{"userID" => userID}) do
    params = conn.query_params
    startTime = checkTime(params["start"], "2000-01-01 00:00:00")
    endTime = checkTime(params["end"], "9999-12-31 23:59:59")

    # Logger.info(endTime)

    workingtimes = TimeContext.get_working_time_by_user(userID, startTime, endTime)
    render(conn, "index.json", workingtimes: workingtimes)
  end

  def create(conn, %{"userID" => userID, "working_time" => working_time_params}) do
    working_time_params = Map.put(working_time_params, "user", userID)
    with {:ok, %WorkingTime{} = working_time} <- TimeContext.create_working_time(working_time_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.working_time_path(conn, :show, userID, working_time))
      |> render("show.json", working_time: working_time)
    end
  end

  def show(conn, %{"userID" => _userID, "id" => id}) do
    working_time = TimeContext.get_working_time!(id)
    render(conn, "show.json", working_time: working_time)
  end

  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = TimeContext.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <- TimeContext.update_working_time(working_time, working_time_params) do
      render(conn, "show.json", working_time: working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = TimeContext.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- TimeContext.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end

  def get_working_time_from_logged_user(conn, _params) do
    index_of_user(conn, %{"userID" => conn.assigns[:user_id]})
  end


  def create_from_logged_user(conn, %{"working_time" => working_time_params}) do
    create(conn, %{"userID" => conn.assigns[:user_id], "working_time" => working_time_params})
  end

end
