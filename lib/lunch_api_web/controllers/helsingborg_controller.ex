alias LunchApiWeb.Scrapers.Helsingborg.{Grytan, PhuunThaiHeden}
alias LunchApiWeb.Scrapers.Aggregators.MatOchMat
alias LunchApiWeb.SlackResponder

defmodule LunchApiWeb.HelsingborgController do
  use LunchApiWeb, :controller

  def index(conn, _params) do
    cache_key = "helsingborg_#{Date.utc_today()}"

    tasks =
      [
        fn -> MatOchMat.city("helsingborg") end,
        fn -> Grytan.menu() end,
        fn -> PhuunThaiHeden.menu() end
      ]
      |> Enum.map(&Task.async/1)

    handle_request(conn, cache_key, tasks)
  end

  def ramlosa(conn, _params) do
    cache_key = "ramlosa_#{Date.utc_today()}"

    tasks =
      [
        fn -> Grytan.menu() end,
        fn -> PhuunThaiHeden.menu() end
      ]
      |> Enum.map(&Task.async/1)

    handle_request(conn, cache_key, tasks)
  end

  def oceanhamnen(conn, _params) do
    cache_key = "oceanhamnen_#{Date.utc_today()}"

    restaurants = [
      "brasseriet",
      "backhaus-oceanhamnen",
      "hamnkrogen-hbg",
      "at-mollberg",
      "bastard-burgers-helsingborg",
      "fahlmans-konditori",
      "restaurang-telegrafen"
    ]

    tasks = Enum.map(restaurants, fn restaurant ->
      Task.async(fn -> MatOchMat.restaurant("helsingborg", restaurant) end)
    end)

    handle_request(conn, cache_key, tasks)
  end

  defp handle_request(conn, cache_key, tasks) do
    menus = get_menus(cache_key, tasks)

    if SlackResponder.slack_request?(conn) do
      text(conn, SlackResponder.format_response(menus))
    else
      json(conn, menus)
    end
  end

  defp get_menus(nil, tasks) do
    LunchApi.MenuFetcher.fetch_menus_concurrently(tasks)
  end

  defp get_menus(cache_key, tasks) do
    LunchApi.Cache.get(cache_key, tasks) || fetch_and_cache_menus(cache_key, tasks)
  end

  defp fetch_and_cache_menus(cache_key, tasks) do
    menus = LunchApi.MenuFetcher.fetch_menus_concurrently(tasks)

    # Cache for 6 hours
    LunchApi.Cache.put(cache_key, menus, ttl: :timer.hours(6))

    menus
  end
end
