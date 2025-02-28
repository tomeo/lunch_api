defmodule LunchApiWeb.RootController do
  use LunchApiWeb, :controller

  def index(conn, _params) do
    json(conn, %{message: "Welcome to Lunch API!"})
  end
end
