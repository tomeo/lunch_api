alias LunchApiWeb.Scrapers.Helsingborg.{Grytan, PhuunThaiHeden}
alias LunchApiWeb.Scrapers.Aggregators.MatOchMat

defmodule LunchApiWeb.HelsingborgController do
  use LunchApiWeb, :controller

  def index(conn, _params) do
    tasks = [
      Task.async(fn -> MatOchMat.city("helsingborg") end),
      Task.async(fn -> Grytan.menu() end),
      Task.async(fn -> PhuunThaiHeden.menu() end)
    ]

    menus = LunchApi.MenuFetcher.fetch_menus_concurrently(tasks)

    if slack_request?(conn) do
      text(conn, format_for_slack(menus))
    else
      json(conn, menus)
    end
  end

  def ramlosa(conn, _params) do
    cache_key = "ramlosa_#{Date.utc_today()}"

    tasks = [
      Task.async(fn -> Grytan.menu() end),
      Task.async(fn -> PhuunThaiHeden.menu() end)
    ]

    menus =
      LunchApi.Cache.get(cache_key, tasks) || fetch_and_cache_menus(cache_key, tasks)

    if slack_request?(conn) do
      text(conn, format_for_slack(menus))
    else
      json(conn, menus)
    end
  end

  def oceanhamnen(conn, _params) do
    cache_key = "oceanhamnen_#{Date.utc_today()}"

    tasks = [
      Task.async(fn -> MatOchMat.restaurant("helsingborg", "brasseriet") end),
      Task.async(fn -> MatOchMat.restaurant("helsingborg", "backhaus-oceanhamnen") end),
      Task.async(fn -> MatOchMat.restaurant("helsingborg", "hamnkrogen-hbg") end),
      Task.async(fn -> MatOchMat.restaurant("helsingborg", "at-mollberg") end),
      Task.async(fn -> MatOchMat.restaurant("helsingborg", "bastard-burgers-helsingborg") end),
      Task.async(fn -> MatOchMat.restaurant("helsingborg", "fahlmans-konditori") end),
      Task.async(fn -> MatOchMat.restaurant("helsingborg", "restaurang-telegrafen") end),
    ]

    menus =
      LunchApi.Cache.get(cache_key) || fetch_and_cache_menus(cache_key, tasks)

    if slack_request?(conn) do
      text(conn, format_for_slack(menus))
    else
      json(conn, menus)
    end
  end

  defp fetch_and_cache_menus(cache_key, tasks) do
    menus = LunchApi.MenuFetcher.fetch_menus_concurrently(tasks)

    # Cache for 6 hours
    LunchApi.Cache.put(cache_key, menus, ttl: :timer.hours(6))

    menus
  end

  defp slack_request?(conn) do
    get_req_header(conn, "x-slack-signature") != [] and
      get_req_header(conn, "x-slack-request-timestamp") != []
  end

  defp format_for_slack(menus) do
    menus
    |> Enum.map(fn menu ->
      dishes_text = menu.dishes
      |> Enum.map(fn dish ->
        price_text = if dish.price != "", do: " (#{dish.price} kr)", else: ""
        "- #{dish.dish}#{price_text}"
      end)
      |> Enum.join("\n")

      "*#{menu.name}:*\n#{dishes_text}"
    end)
    |> Enum.join("\n\n")
  end
end
