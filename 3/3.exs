defmodule Day3 do
  def part1(filename) do
    parse_bits(filename)
    |> Stream.zip
    |> Stream.map(&Tuple.to_list/1)
    |> Stream.map(&most_common_bit/1) 
    # We can just join, look at the number, not it, multiply both and convert ourselves.
  end

  def part2(filename) do
    bits = parse_bits(filename)
    do_search(bits, &most_common_bit/1, []) |> IO.inspect
    do_search(bits, fn d -> most_common_bit(d) |> flip end, []) |> IO.inspect
  end

  def do_search([d], _, found_bits), do: Enum.concat(Enum.reverse(found_bits), d)
  def do_search(data, bit_criteria, found_bits) do
    target_bit = data
                 |> first_bits
                 |> bit_criteria.()

    filtered = data
               |> Enum.filter(fn [bit | _] -> bit == target_bit end)
               |> Enum.map(&Enum.drop(&1, 1))

    do_search(filtered, bit_criteria, [target_bit | found_bits])
  end

  def first_bits(data) do
    Enum.map(data, fn [bit | _] -> bit end)
  end

  def parse_bits(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.graphemes/1)
  end

  def most_common_bit(bits_as_strs) do
    if Enum.count(bits_as_strs, &(&1 == "1")) >= (Enum.count(bits_as_strs)/2) do
      "1"
    else
      "0"
    end
  end

  # Yep I'm that lazy.
  def flip("1"), do: "0"
  def flip("0"), do: "1"
end
