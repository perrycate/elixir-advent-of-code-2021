defmodule Day14 do
  def part1 do
    {template, rules} = parse("input")

    freqs = Enum.reduce(1..10, template, fn _, string -> polymerize(string, rules) end)
    |> String.split("", trim: true)
    |> Enum.frequencies
    |> Enum.map(&elem(&1, 1))

    Enum.max(freqs) - Enum.min(freqs)
  end

  def parse(filename) do
    [template, raw_rules] = File.read!(filename) |> String.split("\n\n")

    rules = raw_rules
            |> String.split("\n", trim: true)
            |> Enum.map(&String.split(&1, " -> ") |> List.to_tuple)
            |> Map.new

    {template, rules}
  end

  def polymerize(template, rules) do
    template
    |> String.split("", trim: true)
    |> Enum.chunk_every(2, 1)
    |> Enum.map(fn 
      [l, _r] = pair -> 
        pair = List.to_string(pair)
        if Map.has_key?(rules, pair) do
          [l, Map.get(rules, pair)] |> List.to_string
        else
          l # No need to include r, as each r is the l of the next chunk.
        end
      [l] -> l # The trailing "pair" with 1 element.
    end)
    |> List.to_string
  end
end

