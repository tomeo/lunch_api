defmodule LunchApiWeb.Scrapers.Helsingborg.PhuunThaiHeden do
  use HTTPoison.Base

  def menu() do
    url = "https://phuunthai.com/meny/heden-meny/"

    {:ok, response} = HTTPoison.get(url)

    {:ok, parsed_html} = Floki.parse_document(response.body)

    dishes = parsed_html
    |> Floki.find("h3#fancy-title-9 li")
    |> Enum.map(&Floki.text/1)
    |> Enum.map(&String.capitalize/1)
    |> Enum.map(fn dish -> %{ dish: dish, price: "109" } end)

    [%{
      name: "Phuun Thai Heden",
      dishes: dishes
    }]
  end
end
