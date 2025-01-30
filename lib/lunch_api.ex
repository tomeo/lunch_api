alias LunchApi.Scrapers.Aggregators.MatOchMat
alias LunchApi.Scrapers.Helsingborg.Grytan
alias LunchApi.Scrapers.Helsingborg.PhuunThaiHeden

defmodule LunchApi do
  use Plug.Router

  plug :match
  plug :dispatch


  get "/helsingborg/oceanhamnen" do
    restaurants = [
      "Brasseriet",
      "Backhaus Oceanhamnen"
    ]
    menu = MatOchMat.city("helsingborg")
    |> Enum.filter(fn restaurant -> Enum.member?(restaurants, restaurant.name) end)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(menu))
  end

  get "/helsingborg/ramlosa" do
    menu =
      [Grytan.menu()]
      ++ [PhuunThaiHeden.menu()]

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(menu))
  end

  get "/helsingborg" do
    menu = MatOchMat.city("helsingborg")
    ++ [Grytan.menu()]
    ++ [PhuunThaiHeden.menu()]

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(menu))
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
