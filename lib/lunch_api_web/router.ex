defmodule LunchApiWeb.Router do
  use LunchApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LunchApiWeb do
    pipe_through :api

    get "/", RootController, :index

    get "/helsingborg", HelsingborgController, :index
    post "/helsingborg", HelsingborgController, :index

    get "/helsingborg/oceanhamnen", HelsingborgController, :oceanhamnen
    post "/helsingborg/oceanhamnen", HelsingborgController, :oceanhamnen

    get "/helsingborg/ramlosa", HelsingborgController, :ramlosa
    post "/helsingborg/ramlosa", HelsingborgController, :ramlosa

    get "/karlskrona", KarlskronaController, :index
    post "/karlskrona", KarlskronaController, :index

    get "/trelleborg", TrelleborgController, :index
    post "/trelleborg", TrelleborgController, :index
  end


  if Application.compile_env(:lunch_api, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: LunchApiWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
