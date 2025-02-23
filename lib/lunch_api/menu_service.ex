defmodule LunchApi.MenuService do
  @moduledoc """
  Provides functions to fetch menus concurrently with optional caching.
  """

  def get_menus(nil, tasks) do
    LunchApi.MenuFetcher.fetch_menus_concurrently(tasks)
  end

  def get_menus(cache_key, tasks) do
    LunchApi.Cache.get(cache_key, tasks) || fetch_and_cache_menus(cache_key, tasks)
  end

  defp fetch_and_cache_menus(cache_key, tasks) do
    menus = LunchApi.MenuFetcher.fetch_menus_concurrently(tasks)
    # Cache for 24 hours
    LunchApi.Cache.put(cache_key, menus, ttl: :timer.hours(24))
    menus
  end
end
