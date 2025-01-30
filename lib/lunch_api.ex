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
    tasks = [
      Task.async(fn -> Grytan.menu() end),
      Task.async(fn -> PhuunThaiHeden.menu() end)
    ]

    fetch_menus_concurrently(tasks)
    |> return_json(conn)
  end

  get "/helsingborg" do
    tasks = [
      Task.async(fn -> MatOchMat.city("helsingborg") end),
      Task.async(fn -> Grytan.menu() end),
      Task.async(fn -> PhuunThaiHeden.menu() end)
    ]

    fetch_menus_concurrently(tasks)
    |> return_json(conn)
  end

  defp return_json(data, conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(data))
  end

  defp fetch_menus_concurrently(tasks) do
    Enum.map(tasks, &Task.await/1)
    |> Enum.concat
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
