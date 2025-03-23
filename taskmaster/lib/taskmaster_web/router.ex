defmodule TaskmasterWeb.Router do
  use TaskmasterWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TaskmasterWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TaskmasterWeb do
    pipe_through :browser

    get "/", PageController, :home

    # User routes
    resources "/users", UserController

    # BigTask routes
    resources "/big-tasks", BigTaskController

    # Task routes
    resources "/tasks", TaskController

    # Category routes
    resources "/categories", CategoryController

    # Shared BigTask routes
    resources "/shared-big-tasks", SharedBigTaskController, except: [:edit, :update]
  end

  # Other scopes may use custom stacks.
  # scope "/api", TaskmasterWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:taskmaster, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TaskmasterWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
