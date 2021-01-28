defmodule AdvanceWeb.Router do
  use AdvanceWeb, :router

  import AdvanceWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :set_session_locale
    plug :fetch_live_flash
    plug :put_root_layout, {AdvanceWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug AdvanceWeb.Context
  end

  scope "/" do
    pipe_through :api

    forward "/api", Absinthe.Plug, schema: AdvanceWeb.Schema

    if Mix.env() == :dev do
      forward "/graphiql", Absinthe.Plug.GraphiQL,
        schema: AdvanceWeb.Schema,
        socket: AdvanceWeb.UserSocket
    end
  end

  scope "/", AdvanceWeb do
    pipe_through :browser

    live "/", PageLive, :index
  end

  scope "/", AdvanceWeb do
    pipe_through [:browser, :require_admin_user]

    live "/categories", CategoryLive.Index, :index
    live "/categories/new", CategoryLive.Index, :new
    live "/categories/:id/edit", CategoryLive.Index, :edit
    live "/categories/:id", CategoryLive.Show, :show
    live "/categories/:id/show/edit", CategoryLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", AdvanceWeb do
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
      live_dashboard "/dashboard", metrics: AdvanceWeb.Telemetry
    end
  end

  ## Authentication routes

  scope "/", AdvanceWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated, :put_session_layout]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", AdvanceWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/update_password", UserSettingsController, :update_password
    put "/users/settings/update_password", UserSettingsController, :update_password
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
    get "/users/settings/update_avatar", UserSettingsController, :update_avatar
    put "/users/settings/update_avatar", UserSettingsController, :update_avatar
    get "/users/settings/update_profile", UserSettingsController, :update_profile
    put "/users/settings/update_profile", UserSettingsController, :update_profile
    get "/users/settings/update_locale/:locale", UserSettingsController, :update_locale
  end

  scope "/", AdvanceWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm
  end

  defp set_session_locale(conn, _opts) do
    locale =
      case get_session(conn, :locale) do
        nil -> "en"
        result -> result
      end

    Gettext.put_locale(AdvanceWeb.Gettext, locale)

    conn
  end

  # if Mix.env == :dev do
  #   forward "/sent_emails", Bamboo.SentEmailViewerPlug
  # end
end
