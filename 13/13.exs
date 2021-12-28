defmodule Day13 do 
  def part1 do
    {coords, _} = parse("input")
    coords
    |> Enum.map(&fold(&1, "x", 655)) # First instruction lol.
    |> MapSet.new
    |> Enum.count
  end

  def part2 do
    {coords, instructions} = parse("input")

    folded_coords = instructions
             |> Enum.reduce(coords, fn {dir, axis}, coords ->
               coords
               |> Enum.map(&fold(&1, dir, axis))
               |> MapSet.new
             end)

    # Finesse into printable format.
    dots_per_line = folded_coords
                    |> Enum.group_by(&elem(&1, 1), &elem(&1, 0))

    for y <- 0..Enum.max(Map.keys(dots_per_line)) do
      for x <- 0..Enum.max(dots_per_line[y]) do
        # Cubic but idc.
        # If we need to make it more efficient, turn each value in dots_per_line into a set.
        if x in dots_per_line[y] do
          IO.write "*"
        else
          IO.write " "
        end
      end
      IO.write "\n"
    end
  end

  def parse(filename) do
    [raw_coords, raw_instructions] = File.read!(filename) |> String.split("\n\n")

    coords = for line <- String.split(raw_coords, "\n"), into: %MapSet{} do
      line
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple
    end

    instructions = for line <- String.split(raw_instructions, "\n", trim: true), [] do
      line
      |> IO.inspect
      |> String.split("=")
      |> then(fn [axis_str, num] ->
        {String.at(axis_str, -1), String.to_integer(num)}
      end)
    end
    {coords, instructions}
  end

  def fold({x, y}, "x", axis), do: {fold_val(x, axis), y}
  def fold({x, y}, "y", axis), do: {x, fold_val(y, axis)}

  def fold_val(value, axis) when axis > value, do: value
  def fold_val(value, axis), do: value - 2*(value-axis)
end
