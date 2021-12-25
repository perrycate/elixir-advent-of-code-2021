defmodule Day11 do
  def part1 do
    initial_state = parse("input")
    {_, count} = Enum.reduce(
      1..100,
      {initial_state, 0},
      fn _, {state, count} ->
        {next_state, new_flashes} = perform_step(state)
        {next_state, count + new_flashes}
      end)
  end

  def parse(filename) do
    File.stream!(filename)
    |> Enum.map(fn line ->
      line
      |> String.trim
      |> String.to_charlist
      |> Stream.map(fn c -> c - ?0 end)
      |> Enum.with_index
    end)
    |> Enum.with_index(fn row, row_idx ->
      Enum.map(row, fn {val, col_idx} -> {{row_idx, col_idx}, val} end)
    end)
    |> List.flatten
    |> Map.new
  end

  def increment(octos) do
    Enum.map(octos, fn {coord, val} -> {coord, val+1} end)
    |> Map.new
  end

  def perform_step(octos) do
    octos = increment(octos) # Increment everything.
    octos = octos
    |> Enum.filter(fn {_, v} -> v > 9 end)  # Find initial flashes.
    |> Enum.map(fn {coords, _} -> coords end)
    |> Enum.reduce(  # Propogate initial flashes.
      {octos, MapSet.new()},
      fn flasher, {octos, visited} -> propagate_flashes(octos, flasher, visited) end)
    |> then(fn {octos, _} -> octos end)
    |> Enum.map(fn # Reset anything that flashed to 0.
      {c, v} when v > 9 -> {c, 0}
      octo -> octo
    end)
    |> Map.new
    {octos, octos |> Enum.count(fn {_, v} -> v == 0 end)}
  end

  def propagate_flashes(octos, c, visited) do
    if (octos[c] <= 9) or MapSet.member?(visited, c) do
      {octos, visited}
    else # Flash!
      visited = MapSet.put(visited, c)
      neighbors = neighbors_of(c) |> Enum.filter(&Map.has_key?(octos, &1))

      # Increment neighbors.
      octos = neighbors 
      |> Enum.reduce(octos, 
        fn neighbor, octos -> Map.update!(octos, neighbor, fn v -> v+1 end) end)

      # Recurse.
      neighbors
      |> Enum.reduce({octos, visited}, 
        fn neighbor, {octos, visited} -> propagate_flashes(octos, neighbor, visited) end)
      
    end
  end
  
  def neighbors_of({i, j}) do
    [
      {i-1, j-1}, {i-1, j}, {i-1, j+1},
      {i,   j-1}, {i,   j}, {i,   j+1},
      {i+1, j-1}, {i+1, j}, {i+1, j+1},
    ]
  end
end
