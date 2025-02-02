defmodule LunchApiWeb.Router do
  use LunchApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LunchApiWeb do
    pipe_through :api

    match :get, "/helsingborg", HelsingborgController, :index
    match :post, "/helsingborg", HelsingborgController, :index

    match :get, "/helsingborg/oceanhamnen", HelsingborgController, :oceanhamnen
    match :post, "/helsingborg/oceanhamnen", HelsingborgController, :oceanhamnen

    match :get, "/helsingborg/ramlosa", HelsingborgController, :ramlosa
    match :post, "/helsingborg/ramlosa", HelsingborgController, :ramlosa

    match :get, "/karlskrona", KarlskronaController, :index
    match :post, "/karlskrona", KarlskronaController, :index

    match :get, "/trelleborg", TrelleborgController, :index
    match :post, "/trelleborg", TrelleborgController, :index
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
