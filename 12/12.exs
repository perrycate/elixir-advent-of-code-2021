defmodule Day12 do
  def part1 do
    find_paths("start", parse("input"), MapSet.new())
  end

  def part2 do
    find_paths("start", parse("input"), MapSet.new(), 1)
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

  def find_paths(_cave, _map, _visited, _bonus \\ 0)
  def find_paths("end", _map, _visited, _bonus), do: 1
  def find_paths(cave, map, visited, bonus) do
    if cave in visited and (cave == "start" or bonus <= 0) do
      0
    else
      bonus = if cave in visited, do: bonus-1, else: bonus

      visited = if is_lowercase(cave) do # Don't revisit small (lowercase) caves.
                  MapSet.put(visited, cave)
                else
                  visited
                end

      map[cave]
      |> Enum.map(&find_paths(&1, map, visited, bonus))
      |> Enum.sum
    end
  end

  def is_lowercase(str) do
      String.downcase(str) == str
  end
end
