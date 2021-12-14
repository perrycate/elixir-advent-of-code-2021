defmodule Day5 do
  def part1 do
    parse("input")
    # Convert lines into lists of coordinates.
    |> Enum.map(fn
      [[x , y1], [x , y2]] -> Enum.map(y1..y2, &({x, &1}))
      [[x1, y ], [x2, y ]] -> Enum.map(x1..x2, &({&1, y}))
      # Ignore diagonal lines.
      _ -> []
    end)
    |> List.flatten
    |> Enum.frequencies
    |> Enum.filter(fn {_, count} -> count > 1 end)
    |> Enum.count
  end

  def part2 do
    parse("input")
    # Convert lines into lists of coordinates.
    |> Enum.map(fn
      [[x , y1], [x , y2]] -> Enum.map(y1..y2, &({x, &1}))
      [[x1, y ], [x2, y ]] -> Enum.map(x1..x2, &({&1, y}))
      [[x1, y1], [x2, y2]] -> diagonal_to_coords(Enum.to_list(x1..x2), Enum.to_list(y1..y2))
    end)
    |> List.flatten
    |> Enum.frequencies
    |> Enum.filter(fn {_, count} -> count > 1 end)
    |> Enum.count
  end

  def diagonal_to_coords([], []), do: []
  def diagonal_to_coords([x | xs], [y | ys]) do
    [{x, y} | diagonal_to_coords(xs, ys)]
  end

  def parse(filename) do
    File.stream!(filename)
    |> Enum.map(fn line ->
      line
      |> String.trim
      |> String.split(" -> ")
      |> Enum.map(fn coords -> String.split(coords, ",") |> Enum.map(&String.to_integer/1) end)
    end)
  end
end
