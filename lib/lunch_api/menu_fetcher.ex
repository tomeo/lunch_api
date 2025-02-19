defmodule LunchApi.MenuFetcher do
  def fetch_menus_concurrently(tasks) do
    Task.await_many(tasks)
    |> Enum.concat()
  end
end
