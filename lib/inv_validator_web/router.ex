defmodule InvValidatorWeb.Router do
  use InvValidatorWeb, :router

  import InvValidatorWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {InvValidatorWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", InvValidatorWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/", InvValidatorWeb do
    pipe_through [:browser, :require_authenticated_user]

    live "/access", SiteAccessLive.Index, :index
    live "/access/new", SiteAccessLive.Index, :new
    live "/access/:id/edit", SiteAccessLive.Index, :edit

    live "/access/:id", SiteAccessLive.Show, :show
    live "/access/:id/show/edit", SiteAccessLive.Show, :edit
  end

  scope "/", InvValidatorWeb do
    pipe_through [:browser, :require_authenticated_user]

    live "/inventory", InventoryLive.Index, :index
    live "/inventory/new", InventoryLive.Index, :new
    live "/inventory/:id/edit", InventoryLive.Index, :edit

    live "/inventory/:id", InventoryLive.Show, :show
    live "/inventory/:id/show/edit", InventoryLive.Show, :edit
  end
  # Other scopes may use custom stacks.
  # scope "/api", InvValidatorWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:inv_validator, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: InvValidatorWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", InvValidatorWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{InvValidatorWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", InvValidatorWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{InvValidatorWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", InvValidatorWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{InvValidatorWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
