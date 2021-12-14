defmodule Day7 do
  # Note to self: Got lucky on this one.
  # If the optimal position isn't in the input positions list, we'll fail.
  # Oops.

  def part1 do
    positions = parse("input")
    p = Enum.min_by(positions, fn x -> linear_fuel_to(positions, x) end)
    linear_fuel_to(positions, p)
  end

  def part2 do
    positions = parse("input")
    p = Enum.min_by(positions, fn x -> quadratic_fuel_to(positions, x) end)
    quadratic_fuel_to(positions, p)
  end

  def linear_fuel_to(positions, target) do
    positions
    |> Enum.reduce(0, fn pos, sum -> sum + abs(pos - target) end)
  end

  def quadratic_fuel_to(positions, target) do
    positions
    |> Enum.reduce(0, fn pos, sum -> 
      d = abs(pos - target)
      sum + (d * (d+1) / 2)
    end)
  end

  def parse(filename) do
    File.read!(filename)
    |> String.trim
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end
