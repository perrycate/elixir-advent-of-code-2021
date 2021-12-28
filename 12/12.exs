defmodule Day12 do
  def part1 do
    find_paths("start", parse("input"), MapSet.new())
  end

  def parse(filename) do
    for line <- File.stream!(filename), into: [] do
      String.trim(line)
      |> String.split("-")
      |> then(fn [a, b] -> [{a, b}, {b, a}] end)
    end
    |> List.flatten
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
  end

  def find_paths("end", _map, _visited), do: 1
  def find_paths(cave, map, visited) do
    if cave in visited do
      0
    else
      visited = if is_lowercase(cave) do # Don't revisit small (lowercase) caves.
                  MapSet.put(visited, cave)
                else
                  visited
                end

      map[cave]
      |> Enum.map(&find_paths(&1, map, visited))
      |> Enum.sum
    end
  end

  def is_lowercase(str) do
      String.downcase(str) == str
  end
end
