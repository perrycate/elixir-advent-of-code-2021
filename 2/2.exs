# 30 minutes total.
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

  def part2(filename) do
    {pos, depth, _} = stream(filename)
    |> Enum.reduce({0, 0, 0}, &process_command/2)
    IO.inspect(pos * depth)
  end

  def process_command({"forward", v}, {pos, depth, aim}), do: {pos+v, depth+v*aim, aim}
  def process_command({"up",      v}, {pos, depth, aim}), do: {pos, depth, aim - v}
  def process_command({"down",    v}, {pos, depth, aim}), do: {pos, depth, aim + v}

  def stream(filename) do
    File.stream!(filename)
    |> Stream.map(&String.split/1)
    |> Stream.map(fn [dir, val] -> {dir, String.to_integer(val)} end)
  end
end

Day2.part2("input")
