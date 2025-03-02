defmodule LunchApi.DataFetcher do
  alias LunchApiWeb.Scrapers.Helsingborg.{Grytan, PhuunThaiHeden}
  alias LunchApiWeb.Scrapers.Aggregators.MatOchMat

  def fetch_helsingborg_data do
    tasks = [
      fn -> MatOchMat.city("helsingborg") end,
      fn -> Grytan.menu() end,
      fn -> PhuunThaiHeden.menu() end
    ]
    |> Enum.map(&Task.async/1)

    Task.await_many(tasks, 15_000)
    |> Enum.reject(&is_nil/1)
  end

  def fetch_ramlosa_data do
    tasks = [
      fn -> Grytan.menu() end,
      fn -> PhuunThaiHeden.menu() end
    ]
    |> Enum.map(&Task.async/1)

    Task.await_many(tasks, 15_000)
    |> Enum.reject(&is_nil/1)
  end

  def fetch_oceanhamnen_data do
    restaurants = [
      "brasseriet",
      "backhaus-oceanhamnen",
      "hamnkrogen-hbg",
      "at-mollberg",
      "bastard-burgers-helsingborg",
      "fahlmans-konditori",
      "restaurang-telegrafen"
    ]

    tasks =
      Enum.map(restaurants, fn restaurant ->
        Task.async(fn -> MatOchMat.restaurant("helsingborg", restaurant) end)
      end)

    Task.await_many(tasks, 15_000)
    |> Enum.reject(&is_nil/1)
  end

  def fetch_karlskrona_data do
    MatOchMat.city("karlskrona")
  end

  def fetch_trelleborg_data do
    MatOchMat.city("trelleborg")
  end
end
