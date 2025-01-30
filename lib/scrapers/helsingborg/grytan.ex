defmodule LunchApi.Scrapers.Helsingborg.Grytan do
  use HTTPoison.Base

  def menu() do
    url = "https://www.grytanrestaurang.se/"

    {:ok, response} = HTTPoison.get(url)

    {:ok, parsed_html} = Floki.parse_document(response.body)

    text = parsed_html
    |> Floki.find("div#comp-kv23q6hz span")
    |> Enum.map(&Floki.text/1)
    |> Enum.join("\n")

    week = [
      text |> between_days("Måndag", "Tisdag"),
      text |> between_days("Tisdag", "Onsdag"),
      text |> between_days("Onsdag", "Torsdag"),
      text |> between_days("Torsdag", "Fredag"),
      text |> between_days("Fredag", "Veckans"),
    ]

    dailies = week |> Enum.at(weekday_number() - 1 |> min(5))

    weekly = text
    |> String.split("Veckans ", parts: 2)
    |> List.last()
    |> String.trim()
    |> clean

    dishes = dailies ++ [weekly]
    |> Enum.map(fn dish -> %{ dish: dish, price: "135" } end)

    [%{
      name: "Grytan",
      dishes: dishes
    }]
  end

  defp clean(str) do
    str
    |> String.replace("\n", "")
    |> String.replace("\u200B", "")
    |> String.trim()
  end

  defp between_days(str, from, to) do
    str
    |> String.split(from, parts: 2)
    |> List.last()
    |> String.split(to, parts: 2)
    |> List.first()
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&clean/1)
  end

  defp weekday_number() do
    Date.utc_today()
    |> Date.day_of_week
  end
end
