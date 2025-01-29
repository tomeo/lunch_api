defmodule LunchApi do
  use Plug.Router

  plug :match
  plug :dispatch


  get "/helsingborg/oceanhamnen" do
    restaurants = [
      "Brasseriet",
      "Backhaus Oceanhamnen"
    ]
    menu = LunchApi.Scrapers.Aggregators.MatOchMat.city("helsingborg")
    |> Enum.filter(fn restaurant -> Enum.member?(restaurants, restaurant.name) end)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(menu))
  end

  get "/helsingborg" do
    menu = LunchApi.Scrapers.Aggregators.MatOchMat.city("helsingborg")

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(menu))
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
