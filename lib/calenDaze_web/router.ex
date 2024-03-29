defmodule CalenDazeWeb.Router do
  use CalenDazeWeb, :router

  import CalenDazeWeb.BusinessAuth

  import CalenDazeWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {CalenDazeWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_business
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CalenDazeWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", CalenDazeWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:calenDaze, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: CalenDazeWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", CalenDazeWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{CalenDazeWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", CalenDazeWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{CalenDazeWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email

      live "/appointments", AppointmentLive.Index, :index
      live "/appointments/new", AppointmentLive.Index, :new
      live "/appointments/:id/edit", AppointmentLive.Index, :edit

      live "/appointments/:id", AppointmentLive.Show, :show
      live "/appointments/:id/show/edit", AppointmentLive.Show, :edit
    end
  end

  scope "/", CalenDazeWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{CalenDazeWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end

  ## Authentication routes

  scope "/", CalenDazeWeb do
    pipe_through [:browser, :redirect_if_business_is_authenticated]

    live_session :redirect_if_business_is_authenticated,
      on_mount: [{CalenDazeWeb.BusinessAuth, :redirect_if_business_is_authenticated}] do
      live "/businesses/register", BusinessRegistrationLive, :new
      live "/businesses/log_in", BusinessLoginLive, :new
      live "/businesses/reset_password", BusinessForgotPasswordLive, :new
      live "/businesses/reset_password/:token", BusinessResetPasswordLive, :edit
    end

    post "/businesses/log_in", BusinessSessionController, :create
  end

  scope "/", CalenDazeWeb do
    pipe_through [:browser, :require_authenticated_business]

    live_session :require_authenticated_business,
      on_mount: [{CalenDazeWeb.BusinessAuth, :ensure_authenticated}] do
      live "/businesses/settings", BusinessSettingsLive, :edit
      live "/businesses/settings/confirm_email/:token", BusinessSettingsLive, :confirm_email

      live "/calendar_confs", CalendarConfLive.Index, :index
      live "/calendar_confs/new", CalendarConfLive.Index, :new
      live "/calendar_confs/:id/edit", CalendarConfLive.Index, :edit

      live "/calendar_confs/:id", CalendarConfLive.Show, :show
      live "/calendar_confs/:id/show/edit", CalendarConfLive.Show, :edit
    end
  end

  scope "/", CalenDazeWeb do
    pipe_through [:browser]

    delete "/businesses/log_out", BusinessSessionController, :delete

    live_session :current_business,
      on_mount: [{CalenDazeWeb.BusinessAuth, :mount_current_business}] do
      live "/businesses/confirm/:token", BusinessConfirmationLive, :edit
      live "/businesses/confirm", BusinessConfirmationInstructionsLive, :new
    end
  end
end
