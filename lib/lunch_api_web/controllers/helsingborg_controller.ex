defmodule LunchApiWeb.HelsingborgController do
  use LunchApiWeb, :controller
  alias LunchApi.DataFetcher
  alias LunchApi.Cache
  alias LunchApiWeb.SlackResponder

  def index(conn, _params) do
    cache_key = "helsingborg_#{Date.utc_today()}"
    data = Cache.get_or_fetch(cache_key, &DataFetcher.fetch_helsingborg_data/0)
    respond(conn, data)
  end

  def ramlosa(conn, _params) do
    cache_key = "ramlosa_#{Date.utc_today()}"
    data = Cache.get_or_fetch(cache_key, &DataFetcher.fetch_ramlosa_data/0)
    respond(conn, data)
  end

  def oceanhamnen(conn, _params) do
    cache_key = "oceanhamnen_#{Date.utc_today()}"
    data = Cache.get_or_fetch(cache_key, &DataFetcher.fetch_oceanhamnen_data/0)
    respond(conn, data)
  end

  defp respond(conn, data) do
    if SlackResponder.slack_request?(conn) do
      text(conn, SlackResponder.format_response(data))
    else
      json(conn, data)
    end
  end
end
