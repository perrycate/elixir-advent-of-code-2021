# 20 minutes.
defmodule Day2 do
  def part1(filename) do
    input = stream(filename)
    sum_moves(input, "forward") * (sum_moves(input, "down")-sum_moves(input, "up"))
    |> IO.inspect
  end

  def sum_moves(input, direction) do
    Stream.filter(input, fn {dir, _} -> dir == direction end)
                       |> Stream.map(fn {_, d} -> d end)
                       |> Enum.sum
  end

  def stream(filename) do
    File.stream!(filename)
    |> Stream.map(&String.split/1)
    |> Stream.map(fn [dir, val] -> {dir, String.to_integer(val)} end)
  end
end

Day2.part1("input")
