defmodule Day9 do
  def part1 do
    depths = parse("input")
    for i <- 0..(tuple_size(depths)-1), j <- 0..(tuple_size(elem(depths, 0))-1) do
      {i, j}
    end
    |> Stream.filter(fn {i, j} ->
      v = get(depths, i, j)
      Enum.all?(neighbors_of(depths, i, j), &(&1 > v))
    end)
    |> Stream.map(fn {i, j} -> 1 + get(depths, i, j) end)
    |> Enum.sum
  end

  def parse(filename) do
    File.stream!(filename)
    |> Stream.map(fn ln -> 
      ln
      |> String.trim
      |> String.graphemes
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple
    end)
    |> Enum.to_list
    |> List.to_tuple
  end

  def neighbors_of(ns, i, j) do
    up   = if i > 0,                do: get(ns, i-1, j), else: Inf
    down = if i < tuple_size(ns)-1, do: get(ns, i+1, j), else: Inf

    left  = if j > 0,                do: get(ns, i, j-1), else: Inf
    right = if j < tuple_size(elem(ns, 0))-1, do: get(ns, i, j+1), else: Inf

    [up, down, left, right]
  end

  def get(double_tuple, i, j), do: elem(elem(double_tuple, i), j)

end
