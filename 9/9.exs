defmodule Day9 do
  def part1 do
    depths = parse("input")
    find_low_points(depths)
    |> Stream.map(fn {i, j} -> 1 + get(depths, i, j) end)
    |> Enum.sum
  end

  def part2 do
    depths = parse("input")
    find_low_points(depths)
    |> Stream.map(fn coord -> explore_basin(depths, [coord], MapSet.new()) end)
    |> Stream.uniq
    |> Stream.map(&MapSet.size/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.reduce(&*/2) # Multiply.
  end

  def explore_basin(_depths, [], visited), do: visited
  def explore_basin(depths, [{i, j} | to_visit], visited) do
    if MapSet.member?(visited, {i, j}) || get(depths, i, j, 9) == 9 do
      explore_basin(depths, to_visit, visited)
    else
      explore_basin(
        depths,
        neighbors_of(i, j) ++ to_visit,
        MapSet.put(visited, {i, j})
      )
    end
  end

  def find_low_points(depths) do
    for i <- 0..(tuple_size(depths)-1), j <- 0..(tuple_size(elem(depths, 0))-1) do
      {i, j}
    end
    |> Enum.filter(fn {i, j} ->
      v = get(depths, i, j)
      Enum.all?(
        neighbors_of(i, j),
        fn {i2, j2} -> get(depths, i2, j2) > v end)
    end)
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

  def neighbors_of(i, j), do: [{i-1, j}, {i+1, j}, {i, j-1}, {i, j+1}]

  def get(double_tuple, i, j, default \\ Inf) do
    if i < 0 ||
       i > (tuple_size(double_tuple)-1) ||
       j < 0 ||
       j > (tuple_size(elem(double_tuple, 0))-1) do
      default
    else
      elem(elem(double_tuple, i), j)
    end
  end

end
