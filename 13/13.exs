defmodule Day13 do 
  
  def part1 do
    {coords, _} = parse("input")
    coords
    |> Enum.map(&fold(&1, "x", 655)) # First instruction lol.
    |> MapSet.new
    |> Enum.count
  end

  def parse(filename) do
    [raw_coords, _raw_instructions] = File.read!(filename) |> String.split("\n\n")

    coords = for line <- String.split(raw_coords, "\n"), into: %MapSet{} do
               line
               |> String.split(",")
               |> Enum.map(&String.to_integer/1)
               |> List.to_tuple
             end

    # TODO(part2) parse instructions.
    {coords, []}
  end

  def fold({x, y}, "x", axis), do: {fold_val(x, axis), y}
  def fold({x, y}, "y", axis), do: {x, fold_val(y, axis)}

  def fold_val(value, axis) when axis > value, do: value
  def fold_val(value, axis), do: value - 2*(value-axis)
end
