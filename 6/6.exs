defmodule Day6 do

  def part1 do
    fish_by_state = parse("input") |> Enum.frequencies
    simulate_days(80, fish_by_state)
    |> Map.values
    |> Enum.sum
  end

  def part2 do
    fish_by_state = parse("input") |> Enum.frequencies
    simulate_days(256, fish_by_state)
    |> Map.values
    |> Enum.sum
  end

  def simulate_days(0, fish), do: fish
  def simulate_days(days, fish) when days > 0 do
    shifted_fish = fish |> Enum.map(fn
      {state, count} -> {state-1, count}
    end)
    |> Map.new
    |> Map.drop([-1])
    |> Map.put(6, Map.get(fish, 7, 0) + Map.get(fish, 0, 0))
    |> Map.put(8, Map.get(fish, 0, 0))

    simulate_days(days-1, shifted_fish)
  end

  def parse(filename) do
    File.read!(filename)
    |> String.trim
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end
