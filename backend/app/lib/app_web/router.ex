defmodule AppWeb.Router do
  use AppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {AppWeb.LayoutView, :root}
    # plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :fetch_session
    plug :fetch_live_flash
    plug :accepts, ["json"]
    plug CORSPlug
    plug :put_secure_browser_headers
  end

  scope "/api" do
    pipe_through :api
    ## User routes ##

    scope "/users", AppWeb do
      get "/", UserController, :index
      get "/:userID", UserController, :show
      post "/", UserController, :create
      put "/:userID", UserController, :update
      put "/", UserController, :update_from_logged_user        # PUT / (for logged user)
      delete "/:userID", UserController, :delete
      post "/login", UserController, :login
      post "/logout", UserController, :logout
      post "/get_login", UserController, :get_login
    end

    ## Working time routes ##

    scope "/workingtimes", AppWeb do
      get "/:userID", WorkingTimeController, :index_of_user           # get (ALL) : /:userID + getParams
      get "/:userID/:id", WorkingTimeController, :show                # GET (ONE) : /:userID/:id
      get "/", WorkingTimeController, :get_working_time_from_logged_user  # GET / : (for logged user)
      post "/:userID", WorkingTimeController, :create                 # POST /:usersID
      post "/", WorkingTimeController, :create_from_logged_user       # POST / (for logged user)
      put "/:id", WorkingTimeController, :update                      # PUT /:id
      delete "/:id", WorkingTimeController, :delete                   # DELETE /:id
    end

    ## Clock routes ##

    scope "/clocks", AppWeb do
      get "/:userID", ClocksController, :get_clock_from_userId      # GET : /:userID
      post "/:userID", ClocksController, :update_clock_from_userId  # POST ( create, update, delete in same call)
      get "", ClocksController, :get_clock_from_logged_user         # GET : / (get actual clock of connected user)
      post "", ClocksController, :update_clock_from_logged_user     # POST ( create, update, delete in same call)
    end
  end
  # Other scopes may use custom stacks.
  # scope "/api", AppWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: AppWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
