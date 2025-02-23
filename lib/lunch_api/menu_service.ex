defmodule LunchApi.MenuService do
  @moduledoc """
  Provides functions to fetch menus concurrently with optional caching.
  """

  def get_menus(nil, tasks) do
    fetch_menus_concurrently(tasks)
  end

  def get_menus(cache_key, tasks) do
    LunchApi.Cache.get(cache_key, tasks) || fetch_and_cache_menus(cache_key, tasks)
  end

  defp fetch_and_cache_menus(cache_key, tasks) do
    menus = fetch_menus_concurrently(tasks)
    # Cache for 24 hours
    LunchApi.Cache.put(cache_key, menus, ttl: :timer.hours(24))
    menus
  end

  defp fetch_menus_concurrently(tasks) do
    Task.await_many(tasks)
    |> Enum.concat()
  end
end
