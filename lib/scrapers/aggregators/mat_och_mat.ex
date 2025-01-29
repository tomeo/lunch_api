defmodule LunchApi.Scrapers.Aggregators.MatOchMat do
  use HTTPoison.Base

  def city(city) do
    url = "https://www.matochmat.se/lunch/#{city}"

    {:ok, response} = HTTPoison.get(url)

    {:ok, parsed_html} = Floki.parse_document(response.body)

    parsed_html
    |> Floki.find("div.lunchMenuListItem")
    |> Enum.map(fn element -> extract_restaurant(element) end)
    |> Enum.filter(fn restaurant -> length(restaurant.dishes) > 0 end)
  end

  defp extract_restaurant(data) do
    name = data
    |> Floki.find("a.lunchMenuListItem__restaurantLink")
    |> Floki.attribute("href")
    |> Enum.at(0)
    |> String.split("/")
    |> Enum.reverse()
    |> Enum.at(1)
    |> String.replace("-", " ")
    |> String.split(" ")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")

    dishes = data
    |> Floki.find("div.lunchDish")
    |> Enum.map(fn element -> extract_dish(element) end)

    %{
      name: name,
      dishes: dishes,
    }
  end

  defp extract_dish(data) do
    price = data
    |> Floki.find("span.lunchDish__price")
    |> Floki.text()
    |> String.trim()

    main = data
    |> Floki.find("span.lunchDish__name--withDots")
    |> Floki.text()
    |> String.trim()

    side = data
    |> Floki.find("span.lunchDish__bottomRow")
    |> Floki.text()
    |> String.trim()

    %{
      dish: "#{main} #{side}",
      price: price,
    }
  end
end
